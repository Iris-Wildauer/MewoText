#include "cJSON.h"
#include "editor_core.h"
#include <stdio.h>

cJSON *parseJSON(const char *json) {
    cJSON *command = cJSON_Parse(json);
    cJSON *arr     = cJSON_GetArrayItem(command, 0);
    cJSON *cmd     = cJSON_GetObjectItem(arr, "cmd");
    cJSON *row     = cJSON_GetObjectItem(arr, "row");
    cJSON *column  = cJSON_GetObjectItem(arr, "column");
    printf("cmd: %s  row: %d  col: %d\n",
           cJSON_GetStringValue(cmd) ? cJSON_GetStringValue(cmd) : "?",
           row    ? (int)cJSON_GetNumberValue(row)    : -1,
           column ? (int)cJSON_GetNumberValue(column) : -1);
    return command;
}
