# Define variables for data directories
EXPORT_DIR=data-export

# Ensure directories exist
ensure-directories:
	mkdir -p $(EXPORT_DIR)

# Define emulator ports based on actual usage
PORTS=9099 5001 8080 9199 4400 4000

# Stop emulators by killing processes using specified ports
stop-emulators:
	@echo "Stopping processes using specified emulator ports..."
	@for port in $(PORTS); do \
	  echo "Checking port $$port..."; \
	  lsof -i :$$port | awk 'NR>1 {print $$2}' | xargs -r kill -9; \
	done
	@echo "All processes on specified ports have been stopped."

# Start emulators and run integration tests
start-emulators: ensure-directories
	@echo "Starting emulators..."
	firebase emulators:start --import=$(EXPORT_DIR) --export-on-exit=$(EXPORT_DIR) --only=firestore,auth,functions,storage &

# Export data from running emulators
export-data: ensure-directories
	firebase emulators:export $(EXPORT_DIR) --force

# Run emulators with script execution and export data on exit
run-script: ensure-directories
	firebase emulators:exec --import=$(EXPORT_DIR) --export-on-exit=$(EXPORT_DIR) --only=firestore,auth,functions,hosting,pubsub,storage ./your-script.js

# Clean data directories (optional)
clean:
	rm -rf $(EXPORT_DIR)

# Enable Firebase Analytics debug mode for a specified app
enable-analytics-debug:
	@echo "Enabling Firebase Analytics debug mode..."
	adb shell setprop debug.firebase.analytics.app com.online.tribes
	@echo "Firebase Analytics debug mode enabled for com.online.tribes"

# Disable Firebase Analytics debug mode
disable-analytics-debug:
	@echo "Disabling Firebase Analytics debug mode..."
	adb shell setprop debug.firebase.analytics.app .none.
	@echo "Firebase Analytics debug mode disabled."
