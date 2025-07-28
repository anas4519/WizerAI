// plugins {
//     id "com.android.application"
//     id "kotlin-android"
//     // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//     id "dev.flutter.flutter-gradle-plugin"
// }

// def localProperties = new Properties()
// def localPropertiesFile = rootProject.file("local.properties")
// if (localPropertiesFile.exists()) {
//     localPropertiesFile.withReader("UTF-8") { reader ->
//         localProperties.load(reader)
//     }
// }

// def flutterVersionCode = localProperties.getProperty("flutter.versionCode")
// if (flutterVersionCode == null) {
//     flutterVersionCode = "1"
// }

// def flutterVersionName = localProperties.getProperty("flutter.versionName")
// if (flutterVersionName == null) {
//     flutterVersionName = "1.0"
// }
// def keystorePropertiesFile = rootProject.file("key.properties")
// def keystoreProperties = new Properties()

// if (keystorePropertiesFile.exists()) {
//     keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
// }

// android {
//     namespace = "com.wizer.career_counsellor"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_1_8
//         targetCompatibility = JavaVersion.VERSION_1_8
//     }
//     kotlinOptions {
//         jvmTarget = "1.8"
//     }

//     defaultConfig {
//         // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//         applicationId = "com.wizer.career_counsellor"
//         // You can update the following values to match your application needs.
//         // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
//         minSdk = flutter.minSdkVersion
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutterVersionCode.toInteger()
//         versionName = flutterVersionName
//     }

//     signingConfigs {
//         debug {
//             keyAlias keystoreProperties['keyAlias']
//             keyPassword keystoreProperties['keyPassword']
//             storeFile file(keystoreProperties['storeFile'])
//             storePassword keystoreProperties['storePassword']
//         }
//         release {
//             keyAlias keystoreProperties['keyAlias']
//             keyPassword keystoreProperties['keyPassword']
//             storeFile file(keystoreProperties['storeFile'])
//             storePassword keystoreProperties['storePassword']
//         }
//     }


//     buildTypes {
//         debug {
//             // TODO: Add your own signing config for the release build.
//             // Signing with the debug keys for now, so `flutter run --release` works.
//             signingConfig = signingConfigs.debug
//         }
//         release {
//             minifyEnabled true
//             shrinkResources true
//             signingConfig signingConfigs.release
//         }
//     }
// }

// flutter {
//     source = "../.."
// }
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.inputStream().use { input ->
        localProperties.load(input)
    }
}

val flutterVersionCode: Int = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName: String = localProperties.getProperty("flutter.versionName") ?: "1.0"

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { input ->
        keystoreProperties.load(input)
    }
}

android {
    namespace = "com.wizer.career_counsellor"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.wizer.career_counsellor"
        // You can update the following values to match your application needs.
        // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
        minSdk = 26
        targetSdk = 35
        versionCode = flutterVersionCode.toInt()
        versionName = flutterVersionName
    }

    signingConfigs {
        getByName("debug") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { path -> project.file(path) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { path -> project.file(path) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("debug") {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("release") {
            isMinifyEnabled = true
            isShrinkResources = true
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}