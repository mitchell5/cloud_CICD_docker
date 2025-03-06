FROM python:3.12.8-slim

#Do not use env as this would persist after the build and would impact your containers, children images
ARG DEBIAN_FRONTEND=noninteractive

# force the stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED=1

# Create a non-root user called "runner"
RUN useradd --uid 10000 -ms /bin/bash runner

# Ensure the user "runner" owns the directory before switching users
WORKDIR /home/runner/app
RUN chown -R runner:runner /home/runner

# Switch to the non-root user
USER 10000

# Ensure the local bin is in the PATH
ENV PATH="/home/runner/.local/bin:$PATH"

# Copy files AFTER switching users to keep correct permissions
COPY ./  ./

# Install Poetry and Dependencies
RUN pip install --no-cache-dir poetry  && \
    poetry config virtualenvs.in-project true && \
    poetry install --only main

# Expose port 8000
EXPOSE 8000

ENTRYPOINT [ "poetry", "run" ]
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT
