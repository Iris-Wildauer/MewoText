#define WEBVIEW_IMPLEMENTATION
#include "webview.h"
#include <stdlib.h>
#include "editor_core.h"
#include "cJSON.h"

#include <sys/socket.h>
#include <netdb.h>
#import <Foundation/Foundation.h>

void startDevServer() {
    int fds[2];
    int fds2[2];
    char buf[100];
    pipe(fds);
    pipe(fds2);
    int pid = fork();
    if (pid < 0) exit(1);

    if (pid == 0) {
        dup2(fds2[1], STDOUT_FILENO);
        close(fds[0]); close(fds[1]);
        close(fds2[0]); close(fds2[1]);
        chdir("MewoText");
        execlp("stdbuf", "stdbuf", "-oL", "npm", "start", (char*)NULL);
        exit(1);
    }

    int pid2 = fork();

    if (pid2 == 0) {
        dup2(fds2[0], STDIN_FILENO);
        dup2(fds[1], STDOUT_FILENO);
        close(fds[0]); close(fds[1]);
        close(fds2[0]); close(fds2[1]);
        execlp("grep","grep","--line-buffered", "Local:", (char*)NULL);
        exit(1);
    }
    else {
        close(fds[1]);
        close(fds2[1]);
        close(fds2[0]);
        dup2(fds[0], STDIN_FILENO);
        read(STDIN_FILENO,buf, 100);
        printf("%s",buf);
        fflush(stdout);
    }
}

static void navigateWhenReady(webview_t w, void *arg) {
    webview_navigate(w, "http://localhost:4200/");
}

void printInput(const char *seq, const char *req, void *arg) {
    webview_t w = (webview_t)arg;
    const char *result = processCommand(req);
    webview_return(w, seq, 0, result);
}


int main(void) {
    startDevServer();
    sleep(3);
    webview_t w = webview_create(1, NULL);
    webview_set_title(w, "Basic Example");
    webview_set_size(w, 480, 320, WEBVIEW_HINT_NONE);
    webview_bind(w, "sendInput", printInput, w);
    webview_bind(w, "onSearchChange", printInput, w);
    webview_bind(w, "save", printInput, w);

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //waitForServer(4200);
        webview_dispatch(w, navigateWhenReady, NULL);
    });

    webview_run(w);
    webview_destroy(w);
    return 0;
}