import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as geohash from "ngeohash";
import * as uuid from "uuid";

// process.env.GOOGLE_APPLICATION_CREDENTIALS =
// // eslint-disable-next-line max-len
// "/Users/jober/Documents/sensitive_files/
// test-auth-72ce8-firebase-adminsdk-i64r0-0c83e7b920.json";

// initialize the Firebase app
// const firebaseConfig = {
//   projectId: "test-auth-72ce8",
// };
admin.initializeApp();

const db = admin.firestore();
const auth = admin.auth();
// // define the Cloud Function
// export const productsNearLocation = functions.https.onCall(async (data) => {
//   // get the latitude/longitude and radius from the arguments
//   const {latitude, longitude, radius, page} = data;

//   // create a GeoPoint instance with the given latitude/longitude
//   const center = new admin.firestore.GeoPoint(latitude, longitude);

//   // query the products in the Firestore collection
//   const query = admin.firestore()
//       .collection("products")

//      ;

//   const paginatedQuery = query.limit(10).offset(page * 10);

//   // get the query snapshot
//   const snapshot = await query.get();

//   // return the products in the snapshot
//   return snapshot.docs;
// });

export const addAdmin = functions.https.onCall((data)=> {
  return admin.auth().getUserByPhoneNumber(data.phoneNumber).then((user)=>{
    return admin.auth().setCustomUserClaims(user.uid, {
      admin: true,
      premium: true,
    });
  });
});


export const addLocationField = functions.https.onCall(async ()=> {
  const batch = db.batch();
  const testCollectionRef = db.collection("testCollections");
  const testList = await testCollectionRef.get();

  testList.forEach((item) => {
    const hash = item.get("geoHash");
    const coords = geohash.decode(hash);
    const lat = coords.latitude;
    const long = coords.longitude;
    const location = new admin.firestore.GeoPoint(lat, long);
    batch.update(item.ref, {"location": location});
  });
  batch.commit();
  return;
});

export const createCustomToken = functions.https.onCall(async (data)=>{
  const uid = data.uid;
  if (uid != null) {
    const customToken = await auth.createCustomToken(uid);
    return {token: customToken, uid: uid};
  } else {
    const newUid = uuid.v4();
    const customToken = await auth.createCustomToken(newUid);

    return {token: customToken,
      uid: newUid,
    };
  }
});


// export const createCustomToken = async function(uid: string) {
//   if (uid != null) {
//     const customToken = await auth.createCustomToken(uid);
//     return {token: customToken};
//   } else {
//     const newUid = uuid.v4();
//     const customToken = await auth.createCustomToken(newUid);
//     return {token: customToken,
//       newUid: newUid,
//     };
//   }
// };
