CXX = c++
CXXFLAGS = -DWEBVIEW_COCOA=1 -std=c++11
FRAMEWORKS = -framework Cocoa -framework WebKit

mewo: mewokilo.c
	$(CC) mewo.c -o mewo -Wall -Wextra -pedantic -std=c99

webview: main.mm
	$(CXX) main.mm editor_core.c cJSON.c $(CXXFLAGS) $(FRAMEWORKS) -o mewo

core: editor_core.c
	$(CC) editor_core.c -o editor_core -Wall -Wextra -pedantic -std=c99

clean:
	rm -f basic_example

#-framework Webkit