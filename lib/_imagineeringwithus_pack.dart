import 'package:_imagineeringwithus_pack/setup/app_base.dart';
import 'package:_imagineeringwithus_pack/setup/app_setup.dart';
import 'package:firebase_core/firebase_core.dart';

import 'src/constants/constants.dart';
import 'src/utils/utils.dart';

imagineeringwithusPackSetup() {
  AppSetup.initialized(
    value: AppSetup(
      env: AppEnv.preprod,
      appColors: AppColors.instance,
      appPrefs: AppPrefs.instance,
    ),
  );
}

const FirebaseOptions firebaseOptionsPREPROD = FirebaseOptions(
  apiKey: "AIzaSyBHV5mvDocRiDUPDQMrhwpdPTLb69yuXZc",
  authDomain: "imagineeringwithus-enwords.firebaseapp.com",
  projectId: "imagineeringwithus-enwords",
  storageBucket: "imagineeringwithus-enwords.appspot.com",
  messagingSenderId: "54059831282",
  appId: "1:54059831282:web:cb947773f93720155e656b",
  measurementId: "G-F1VMQ8028F",
);
