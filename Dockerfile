# Stage 1: Builder
FROM continuumio/miniconda3:23.5.2-0 as builder

# Install necessary packages and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      bash \
      build-essential \
      git && \
    rm -rf /var/lib/apt/lists/*

# Install FFmpeg
RUN conda install -y 'ffmpeg>=4.4.0' -c conda-forge

# Debug: Check conda environment and packages
RUN conda list



# Debug: Check conda environment and packages after installation
RUN conda list

# Set working directory
WORKDIR /usr/local/src

# Copy the application files
COPY . .

# Install the application dependencies
RUN pip --no-cache-dir -v install .

# Stage 2: Final image
FROM debian:bullseye-slim

# Copy conda environment from the builder stage
COPY --from=builder /opt/conda /opt/conda
ENV PATH=/opt/conda/bin:$PATH

# Set working directory
WORKDIR /tmp

# Define the entry point for the container
ENTRYPOINT ["python", "-m", "backgroundremover.cmd.cli"]
