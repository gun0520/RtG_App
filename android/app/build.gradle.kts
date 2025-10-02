import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun localProperties(): Properties {
    val properties = Properties()
    val localPropertiesFile = rootProject.file("local.properties")
    if (localPropertiesFile.exists()) {
        properties.load(FileInputStream(localPropertiesFile))
    }
    return properties
}

val flutterVersionCode = localProperties().getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties().getProperty("flutter.versionName") ?: "1.0"

android {
    namespace = "com.example.realtime_gasorin"
    compileSdk = 36

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        
        // ▼▼▼【修正点①】脱糖化(desugaring)を有効にする設定を追加 ▼▼▼
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    sourceSets {
        getByName("main") {
            java.srcDirs("src/main/kotlin")
        }
    }

    defaultConfig {
        applicationId = "com.example.realtime_gasorin"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(kotlin("stdlib-jdk7"))
    implementation("androidx.multidex:multidex:2.0.1")

    // ▼▼▼【修正点②】脱糖化(desugaring)のためのライブラリを追加 ▼▼▼
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
