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
import { getFirestore, Timestamp } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { setGlobalOptions } from "firebase-functions/v2";

const app = initializeApp();
const db = getFirestore(app);
const messaging = getMessaging(app);

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

    const challengeName = await getChallengeName(challenge);

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

const getChallengeName = async (challenge: any) => {
  const exerciseRef = db.collection("exercises").doc(challenge.exerciseId);
  const exerciseSnapshot = await exerciseRef.get();
  if (!exerciseSnapshot.exists) {
    return;
  }
  const exercise = exerciseSnapshot.data();
  if (!exercise) {
    return;
  }
  return `${challenge.reps} ${exercise.name}`;
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
