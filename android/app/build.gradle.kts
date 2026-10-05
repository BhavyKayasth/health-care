plugins {
    id("com.android.application")

    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration

    id("kotlin-android")

    // The Flutter Gradle Plugin must be applied after the Android
    // and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.health_care"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    //----------------------------------------------------------
    // JAVA / CORE LIBRARY DESUGARING
    //----------------------------------------------------------

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    //----------------------------------------------------------
    // KOTLIN
    //----------------------------------------------------------

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    //----------------------------------------------------------
    // DEFAULT CONFIG
    //----------------------------------------------------------

    defaultConfig {
        applicationId = "com.example.health_care"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    //----------------------------------------------------------
    // BUILD TYPES
    //----------------------------------------------------------

    buildTypes {
        release {
            // Signing with debug keys for now.
            // Allows flutter run --release to work.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

//----------------------------------------------------------
// DEPENDENCIES
//----------------------------------------------------------

dependencies {
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.4"
    )
}

//----------------------------------------------------------
// FLUTTER
//----------------------------------------------------------

flutter {
    source = "../.."
}