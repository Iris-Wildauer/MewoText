#define WEBVIEW_IMPLEMENTATION
#include "webview.h"
#include <stdlib.h>
#include "editor_core.h"


void printInput(const char *seq, const char *req, void *arg) {
    webview_t w = (webview_t)arg;
    parseJSON(req);
    //printf("%s\n", parseJSON(req));
    //printf("Argumente: %s\n", req);
    webview_return(w, seq, 0, req);
}


int main(void) {
    webview_t w = webview_create(1, NULL);
    webview_set_title(w, "Basic Example");
    webview_set_size(w, 480, 320, WEBVIEW_HINT_NONE);
    webview_navigate(w, "http://localhost:4200/");
    webview_bind(w, "sendInput", printInput, w);
    webview_bind(w, "onSearchChange", printInput, w);
    webview_run(w);
    webview_destroy(w);
    return 0;
}