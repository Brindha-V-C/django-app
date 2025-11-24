# ========= STAGE 1: The Builder =========
# We name this stage 'builder' so we can refer to it later
FROM python:3.11-slim AS builder

WORKDIR /app

# Install system dependencies required for building Python packages
# (Simulating a heavy build environment)
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev

COPY requirements.txt .

# Instead of installing, we create "Wheels"
# This builds the packages and puts them in /app/wheels
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt


# ========= STAGE 2: The Runner =========
# We start fresh! No gcc, no apt-get history.
FROM python:3.11-slim

WORKDIR /app

# Create a non-root user for security (Best Practice!)
RUN useradd -m appuser

# COPY artifacts FROM the 'builder' stage
# We grab the pre-built wheels, not the raw code
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .

# Install the packages from the wheels (fast & clean)
RUN pip install --no-cache /wheels/*

# Copy the application code
COPY . .

# Switch to the non-root user
USER appuser

# Run the app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]