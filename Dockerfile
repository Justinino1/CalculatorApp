# Use the official Python image as the base
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt /app/

# Install dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy the rest of the application code into the container
COPY . /app/

# Expose the port the app runs on
EXPOSE 8000

# Define the default command to run the application
CMD ["gunicorn", "CalculatorApp.wsgi:application", "--bind", "0.0.0.0:8000"]
