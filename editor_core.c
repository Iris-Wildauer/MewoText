#include "cJSON.h"
#include "editor_core.h"
#include <stdio.h>

char *parseJSON(const char *json) {
    cJSON *command = cJSON_Parse(json);
    cJSON *arr = cJSON_GetArrayItem(command, 0);
    cJSON *object = cJSON_GetObjectItem(arr, "cmd");
    char  *result = cJSON_PrintUnformatted(object);
    //printf("alles: %s\n", cJSON_Print(command));
    printf("%s\n", cJSON_Print(object));
    return result;
}
