FROM python:3.9-slim

RUN apt-get update \
 && apt-get install -y curl \
 && curl -L https://github.com/mikefarah/yq/releases/download/v4.44.1/yq_linux_amd64 \
    -o /usr/local/bin/yq \
 && chmod +x /usr/local/bin/yq \
 && apt-get clean

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]