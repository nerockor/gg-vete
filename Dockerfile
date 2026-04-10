# ============================================================
# Vet Challenge VR — Docker Build Environment
# Supports: Unreal Engine 5.3 + Android/Oculus compilation
# ============================================================
FROM ghcr.io/epicgames/unreal-engine:dev-5.3 AS base

USER root

# Install Android build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    android-sdk \
    openjdk-17-jdk \
    ant \
    wget \
    unzip \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# ---- Android SDK / NDK Configuration ----
ENV ANDROID_HOME=/usr/lib/android-sdk
ENV ANDROID_NDK_HOME=${ANDROID_HOME}/ndk/25.2.9519653
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/cmdline-tools/latest/bin:${PATH}"

# Download and install NDK r25b (required for UE 5.3 Android builds)
RUN mkdir -p ${ANDROID_HOME}/ndk && \
    wget -q https://dl.google.com/android/repository/android-ndk-r25b-linux.zip -O /tmp/ndk.zip && \
    unzip -q /tmp/ndk.zip -d /tmp/ndk && \
    mv /tmp/ndk/android-ndk-r25b ${ANDROID_NDK_HOME} && \
    rm -rf /tmp/ndk.zip /tmp/ndk

# ---- Project workspace ----
WORKDIR /home/ue4/project

# Copy project files (Unreal side)
COPY Unreal/ ./

# Label
LABEL maintainer="VetChallenge Team" \
      description="Unreal Engine 5.3 build environment for Vet Challenge VR (Android/Oculus)" \
      version="1.0"

# Default: open a shell for interactive use
CMD ["/bin/bash"]
