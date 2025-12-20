// ===============================
// Create Pipeline Job with GenericTrigger (JAVA API)
// Run in: Manage Jenkins -> Script Console
// Required plugin:
// - Generic Webhook Trigger
// ===============================

import jenkins.model.*
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.cps.*
import org.jenkinsci.plugins.workflow.job.properties.DisableConcurrentBuildsJobProperty
import org.jenkinsci.plugins.gwt.*

def jobName = "${job_name}"
def jobDescription = "${job_description}"
def pipelineScript = '''${pipeline_script}'''
def webhookToken = "${webhook_token}"

def jenkins = Jenkins.get()

// Check existing job
def job = jenkins.getItemByFullName(jobName)
if (job != null) {
    println "Pipeline job '$${jobName}' already exists!"
    return
}
// Create pipeline job
job = jenkins.createProject(WorkflowJob, jobName)
// Set pipeline definition
job.definition = new CpsFlowDefinition(pipelineScript, true)
job.setDescription(jobDescription)
// Disable concurrent builds
job.addProperty(new DisableConcurrentBuildsJobProperty())
// ===============================
// CREATE GenericTrigger (JAVA API)
// ===============================
def trigger = new GenericTrigger(
    [], // genericVariables
    [], // genericRequestVariables
    []  // genericHeaderVariables
)

// Set properties via setters (DataBoundSetter)
trigger.setToken(webhookToken)
trigger.setCauseString("Triggered by Generic Webhook")
trigger.setPrintPostContent(true)
trigger.setPrintContributedVariables(true)
trigger.setSilentResponse(false)
// ADD trigger to job
job.addTrigger(trigger)
// Save job
job.save()

println "Pipeline job '$${jobName}' created successfully with GenericTrigger!"