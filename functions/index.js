/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
const admin=require("firebase-admin");
const auth=require("firebase-auth");

var serviceAccount = require("./health10293-firebase-adminsdk-wlljd-7fe8dc5cc8.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.createCustomToken = functions.region("asia-northeast3").https.onRequest(async (request, response) => {
  const user = request.body;

  const uid = `kakao:${user.uid}`;
  const updateParams = {
    photoURL: user.photoURL,
    displayName: user.displayName,
  };

  if (user.email) {
    updateParams.email = user.email;
  }

  try {
    await admin.auth().updateUser(uid, updateParams);
  } catch (e) {
    updateParams["uid"] = uid;
    if (user.email) {
      updateParams.email = user.email;
    }
    await admin.auth().createUser(updateParams);
  }

  const token = await admin.auth().createCustomToken(uid);
  response.send(token);
});