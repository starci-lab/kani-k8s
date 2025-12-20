// import org.jenkinsci.plugins.plaincredentials.impl.StringCredentialsImpl
// import com.cloudbees.plugins.credentials.CredentialsScope
// import com.cloudbees.plugins.credentials.CredentialsProvider
// import com.cloudbees.plugins.credentials.domains.Domain
// import hudson.util.Secret
// import org.jenkinsci.plugins.github.config.GitHubPluginConfig
// import org.jenkinsci.plugins.github.config.GitHubServerConfig
// import jenkins.model.Jenkins
// import com.cloudbees.plugins.credentials.SystemCredentialsProvider
// import org.jenkinsci.plugins.github.config.HookSecretConfig

// // configure credentials
// def credentialsId = "${credentials_id}"
// def credentialsDescription = "${credentials_description}"
// def accessToken = "${access_token}"

// // configure hook secret
// def hookSecretId = "${hook_secret_id}"
// def hookSecretDescription = "${hook_secret_description}"
// def hookSecret = "${hook_secret}"

// // configure github server name
// def serverName = "${server_name}"

// def domain = Domain.global()

// // create jenkins instance
// def store = Jenkins.get().getExtensionList(SystemCredentialsProvider.class)[0].getStore()

// // Add GitHub access token if not already present
// if (store.getCredentials(domain).find { it.id == credentialsId } == null) {
//   def credentialsText = new StringCredentialsImpl(
//       CredentialsScope.GLOBAL,
//       credentialsId,
//       credentialsDescription,
//       Secret.fromString(accessToken)
//   )
//   store.addCredentials(domain, credentialsText)
// }

// // configure github plugin
// def github = Jenkins.get().getExtensionList(GitHubPluginConfig.class)[0]

// // configure github server
// def githubServerConfig = new GitHubServerConfig(credentialsId)
// githubServerConfig.setName(serverName)  // Set the name of the GitHub server for easy identification

// // Add hook secret if not already present
// if (store.getCredentials(domain).find { it.id == hookSecretId } == null) {
//   def hookSecretText = new StringCredentialsImpl(
//       CredentialsScope.GLOBAL,
//       hookSecretId,
//       hookSecretDescription,
//       Secret.fromString(hookSecret)
//   )
//   store.addCredentials(domain, hookSecretText)
// }

// // create hook secret configuration
// def hookSecretConfig = new HookSecretConfig(hookSecretId)

// // set configurations
// github.setConfigs([
//   githubServerConfig,
//   hookSecretConfig
// ])

// // save configurations
// github.save()

// println "GitHub credentials and hook secret have been successfully configured."