CXX = c++
CXXFLAGS = -DWEBVIEW_COCOA=1 -std=c++11
FRAMEWORKS = -framework Cocoa -framework WebKit

mewo: mewokilo.c
	$(CC) mewo.c -o mewo -Wall -Wextra -pedantic -std=c99

webview: main.mm
	$(CXX) main.mm $(CXXFLAGS) $(FRAMEWORKS) -o basic_example

clean:
	rm -f basic_example

#-framework Webkit