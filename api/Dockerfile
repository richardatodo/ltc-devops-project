# --- Base Image ---
FROM python:3.11-slim

# Set environment variables to prevent Python from writing pyc files and buffering stdout/stderr
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /app

# --- Install Dependencies ---
COPY requirements.txt .

# Install Python dependencies
# --no-cache-dir reduces image size slightly
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the working directory
COPY . .

# --- Expose Port ---
EXPOSE 8000

# --- Run Application ---
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]