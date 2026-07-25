allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Workaround : vosk_flutter_service fixe compileSdk=33 dans son propre
// build.gradle alors que ses dépendances androidx exigent compileSdk>=34.
// Doit être enregistré tôt (avant evaluationDependsOn ci-dessous) pour que
// afterEvaluate soit encore valide sur tous les sous-projets.
subprojects {
    afterEvaluate {
        extensions.findByType(com.android.build.gradle.LibraryExtension::class.java)?.let {
            it.compileSdk = 36
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
