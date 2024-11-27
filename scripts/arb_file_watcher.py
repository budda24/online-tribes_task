from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import subprocess
import time
import os

class ARBFileChangeHandler(FileSystemEventHandler):
    def on_modified(self, event):
        if event.src_path.endswith(".arb"):
            print(f"{event.src_path} has been modified, running 'flutter pub get'")
            subprocess.run(["flutter", "pub", "get"], check=True)

if __name__ == "__main__":
    path = os.path.join(os.getcwd(), "lib", "l10n")  # Adjust path to your arb file location
    event_handler = ARBFileChangeHandler()
    observer = Observer()
    observer.schedule(event_handler, path, recursive=False)
    observer.start()
    print(f"Watching for changes in {path}")
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        observer.stop()
    observer.join()
