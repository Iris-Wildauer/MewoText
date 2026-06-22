#include "cJSON.h"
#include "editor_core.h"
#include <stdio.h>
#include <string.h>

static int saveFile(const char *text, const char *filename) {
    FILE *fp = fopen(filename, "w");
    if (!fp) return -1;
    fputs(text, fp);
    fclose(fp);
    return 0;
}

const char *processCommand(const char *json) {
    cJSON *command = cJSON_Parse(json);
    if (!command) return "null";

    cJSON *arr    = cJSON_GetArrayItem(command, 0);
    cJSON *cmdObj = cJSON_GetObjectItem(arr, "cmd");
    const char *cmd = cJSON_GetStringValue(cmdObj);

    if (cmd && strcmp(cmd, "save") == 0) {
        cJSON *filenameObj = cJSON_GetObjectItem(arr, "filename");
        const char *filename = cJSON_GetStringValue(filenameObj);
        cJSON *textObj = cJSON_GetObjectItem(arr, "text");
        const char *text = cJSON_GetStringValue(textObj);
        int ok = text && filename && saveFile(text, filename) == 0;
        cJSON_Delete(command);
        return ok ? "{\"status\":\"ok\"}" : "{\"error\":\"save failed\"}";
    }

    cJSON_Delete(command);
    return json;
}
