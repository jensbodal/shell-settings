# Install the package
pip install -U crawl4ai

# For pre release versions
pip install crawl4ai --pre

# Run post-installation setup
crawl4ai-setup

# Verify your installation
crawl4ai-doctor

# Pull and run the latest release candidate
docker pull unclecode/crawl4ai:0.6.0-rN # Use your favorite revision number
docker run -d -p 11235:11235 --name crawl4ai --shm-size=1g unclecode/crawl4ai:0.6.0-rN # Use your favorite revision number

# Visit the playground at http://localhost:11235/playground
