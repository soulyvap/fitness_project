/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { getMessaging, Message } from "firebase-admin/messaging";
import { initializeApp } from "firebase-admin/app";
import { DocumentData, FieldValue, getFirestore, Timestamp } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { onDocumentCreated, onDocumentDeleted, onDocumentUpdated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";

const app = initializeApp();
const db = getFirestore(app);
const messaging = getMessaging(app);
const storage = getStorage(app);

setGlobalOptions({ region: 'europe-west1' });

export const onChallengeCreated = onDocumentCreated(
  "challenges/{challengeId}",
  async (event) => {
    if (!event.data) {
      return;
    }
    const challenge = event.data.data();
    if (!challenge) {
      return;
    }
    const groupId = challenge.groupId;
    if (!groupId) {
      return;
    }
    const group = await getGroup(groupId);
    if (!group) {
      return;
    }
    console.log("Group", group.toString());
    const members = group.members.filter((m: string) => m !== challenge.userId);
    console.log("Members", members);
    if (!members || members.length === 0) {
      return;
    }
    const tokens = await getFcmTokens(members);
    if (!tokens) {
      return;
    }

    const challengeName = challenge.title;

    if (!challengeName) {
      return;
    }

    const user = await getUser(challenge.userId);

    if (!user) {
      return;
    }

    const messages = tokens.map((token) => {
      const message: Message = {
        notification: {
          title: `New challenge by ${user.displayName}!`,
          body: `You have ${challenge.minutesToComplete} minutes to complete ${challengeName}.\nChallenge ends at ${formatTimestampToHHMM(challenge.endsAt)}`,
          imageUrl: group.imageUrl,
        },
        data: {
          type: "challenge",
          challengeId: event.params.challengeId,
        },
        token,
        android: {
          notification: {
            sound: "default",
            priority: "high",
            channelId: "com.example.fitness_project_challenge_start",
            imageUrl: group.imageUrl,
            visibility: "public",
          }
        },
      };
      return message;
    });
    return await sendNotifications(messages);
  }
);

function formatTimestampToHHMM(timestamp: Timestamp): string {
  const date = timestamp.toDate();
  const hours = date.getHours().toString().padStart(2, '0');
  const minutes = date.getMinutes().toString().padStart(2, '0');

  return `${hours}:${minutes}`;
}

const getGroup = async (groupId: string) => {
  const groupRef = db.collection("groups").doc(groupId);
  const groupSnapshot = await groupRef.get();
  if (!groupSnapshot.exists) {
    return;
  }
  return groupSnapshot.data();
};

const getUser = async (userId: string) => {
  const userRef = db.collection("users").doc(userId);
  const userSnapshot = await userRef.get();
  if (!userSnapshot.exists) {
    return;
  }
  return userSnapshot.data();
};

const getFcmTokens = async (userIds: string[]) => {
  const refs = userIds.map((userId) => db.collection("fcmTokens").doc(userId));
  const snapshots = await db.getAll(...refs);
  const tokens: string[] = [];
  snapshots.forEach((snapshot) => {
    if (snapshot.exists) {
      const data = snapshot.data();
      if (data) {
        tokens.push(data.token);
      }
    }
  });
  return tokens;
};

const sendNotifications = async (messages: Message[]) => {
  await messaging.sendEach(messages);
};

export const onSubmissionDeleted = onDocumentDeleted("submissions/{submissionId}", async (event) => {
  if (!event.data) {
    return;
  }
  const submission = event.data.data();
  if (!submission) {
    return;
  }
  handleSubmissionCancellation(submission, true);
});

const handleSubmissionCancellation = async (submission: DocumentData, removeFiles: boolean) => {
  const submissionId = submission.submissionId;
  const challengeId = submission.challengeId;
  if (!challengeId) {
    return;
  }
  const challenge = await getChallenge(challengeId);
  if (!challenge) {
    return;
  }
  const completedBy = challenge.completedBy;
  const userPosition = completedBy.indexOf(submission.userId) + 1;
  await removeSubmissionPoints(submissionId);
  await removeCompletedBy(submission);
  if (removeFiles) {
    await removeSubmissionFiles(submissionId, challengeId);
  }
  if (userPosition > 5) {
    return;
  }
  if (completedBy.length == 1) {
    return;
  }
  await editEarlySubmissionScores(challengeId)
}

const removeCompletedBy = async (submission: DocumentData) => {
  const challengeRef = db.collection("challenges").doc(submission.challengeId);
  await challengeRef.update({
    "completedBy": FieldValue.arrayRemove(submission.userId),
  });
};

const getChallenge = async (challengeId: string) => {
  const challengeRef = db.collection("challenges").doc(challengeId);
  const challengeSnapshot = await challengeRef.get();
  if (!challengeSnapshot.exists) {
    return;
  }
  return challengeSnapshot.data();
}

const removeSubmissionPoints = async (submissionId: string) => {
  const q = db.collection("scores").where("submissionId", "==", submissionId);
  const querySnapshot = await q.get();
  const batch = db.batch();
  querySnapshot.forEach((doc) => {
    batch.delete(doc.ref);
  });
  await batch.commit();
};

const editEarlySubmissionScores = async (challengeId: string) => {
  const challenge = await getChallenge(challengeId);
  if (!challenge) {
    return;
  }
  const groupId = challenge.groupId;
  const completedBy = challenge.completedBy as string[];
  const top5 = completedBy.slice(0, Math.min(completedBy.length, 5));
  const scores = await getScoresByChallengeId(challengeId);
  const batch = db.batch();
  top5.forEach((userId, index) => {
    const score = scores.find((s) => s.userId === userId && s.type.includes("challengeEarlyParticipation"));
    if (score) {
      const updateMap = {
        "type": `challengeEarlyParticipation${index + 1}`,
        "points": 10 - index * 2,
      }
      batch.update(db.collection("scores").doc(score.scoreId), updateMap);
    } else {
      const ref = db.collection("scores").doc();
      const participationScore = scores.find((s) => s.userId === userId && s.type === "challengeParticipation");
      const newScore = {
        "challengeId": challengeId,
        "userId": userId,
        "type": `challengeEarlyParticipation${index + 1}`,
        "points": 10 - index * 2,
        "groupId": groupId,
        "scoreId": ref.id,
        "submissionId": participationScore?.submissionId,
        "createdAt": FieldValue.serverTimestamp(),
      };
      batch.set(ref, newScore);
    }
  });
  await batch.commit();
};

const getScoresByChallengeId = async (challengeId: string) => {
  const q = db.collection("scores").where("challengeId", "==", challengeId);
  const querySnapshot = await q.get();
  const scores: any[] = [];
  querySnapshot.forEach((doc) => {
    scores.push(doc.data());
  });
  return scores;
};

const removeSubmissionFiles = async (submissionId: string, challengeId: string) => {
  try {
    const bucket = storage.bucket();
    const challengeFolder = `videos/challenges/${challengeId}`;
    const submissionFolder = `${challengeFolder}/submissions/${submissionId}`;
    await bucket.deleteFiles({ prefix: submissionFolder });
  } catch (error) {
    console.error("Error removing submission files", error);
  }
};

export const onSubmissionUpdated = onDocumentUpdated("submissions/{submissionId}", async (event) => {
  if (!event.data) {
    return;
  }
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (before.cancelledAt == null && after.cancelledAt != null) {
    await handleSubmissionCancellation(before, false);
  }
});


