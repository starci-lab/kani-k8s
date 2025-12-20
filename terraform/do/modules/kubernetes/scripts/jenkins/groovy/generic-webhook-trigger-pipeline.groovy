// import org.jenkinsci.plugins.gwt.GenericTrigger
// import org.jenkinsci.plugins.gwt.GenericVariable
// import org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty
// import hudson.triggers.Trigger

// def genericTrigger = new GenericTrigger(
//   [
//     new GenericVariable("APP_NAME", "\$.app")
//   ],
//   [],
//   [],
//   "Deploy app: \$APP_NAME",
//   "${webhook_token}",
//   false,
//   false,
//   false
// )

// // Print confirmation
// println "Generic Webhook Trigger Pipeline has been successfully added to Jenkins."