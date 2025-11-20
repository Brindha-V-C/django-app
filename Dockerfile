# We use the lightweight 'slim' version of Python 3.11
FROM python:3.11-slim

# Set the folder inside the container where we will work
WORKDIR /app

# Copy everything from your current folder (.) to the container (.)
COPY . .

# Install the dependencies
RUN pip install -r requirements.txt

# Command to run the server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]