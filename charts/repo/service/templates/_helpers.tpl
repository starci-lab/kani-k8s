{{/*
Return the proper service image name
*/}}
{{- define "service.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.names.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the configmap env vars
*/}}
{{- define "service.envVarsConfigMapName" -}}
{{ printf "%s-env-vars" (include "common.names.fullname" .) }}
{{- end -}}

{{/*
Create the name of the secret env vars
*/}}
{{- define "service.envVarsSecretName" -}}
{{ printf "%s-env-vars" (include "common.names.fullname" .) }}
{{- end -}}

{{- define "service.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image .Values.volumePermissions.image) "context" $) -}}
{{- end -}}

{{/* 
Get  the health check port
*/}}
{{- define "service.healthCheckPort" -}}
{{- if .Values.separateHealthCheckPort -}}
{{ .Values.separateHealthCheckPort }}
{{- else -}}
{{ .Values.containerPorts.app }}
{{- end -}}
{{- end -}}