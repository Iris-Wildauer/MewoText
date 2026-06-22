#define WEBVIEW_IMPLEMENTATION
#include "webview.h"
#include <stdlib.h>
#include "editor_core.h"
#include "cJSON.h"

#import <Foundation/Foundation.h>


static void navigateWhenReady(webview_t w, void *arg) {
    webview_navigate(w, "http://localhost:4200/");
}

static void startDevServer(webview_t w) {
    int fds[2];
    pipe(fds);

    if (fork() == 0) {
        dup2(fds[1], STDOUT_FILENO);
        close(fds[0]); close(fds[1]);
        chdir("MewoText");
        execlp("npm", "npm", "start", (char *)NULL);
        exit(1);
    }

    close(fds[1]);
    int read_fd = fds[0];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        char buf[256];
        ssize_t n;
        BOOL navigated = NO;
        while ((n = read(read_fd, buf, sizeof(buf) - 1)) > 0) {
            if (!navigated) {
                buf[n] = '\0';
                if (strstr(buf, "Local:")) {
                    navigated = YES;
                    webview_dispatch(w, navigateWhenReady, NULL);
                }
            }
        }
        close(read_fd);
    });
}

void printInput(const char *seq, const char *req, void *arg) {
    webview_t w = (webview_t)arg;
    const char *result = processCommand(req);
    webview_return(w, seq, 0, result);
}


int main(void) {
    webview_t w = webview_create(1, NULL);
    webview_set_title(w, "MewoText");
    webview_set_size(w, 480, 320, WEBVIEW_HINT_NONE);
    webview_bind(w, "sendInput", printInput, w);
    webview_bind(w, "save", printInput, w);

    startDevServer(w);

    webview_run(w);
    webview_destroy(w);
    return 0;
}