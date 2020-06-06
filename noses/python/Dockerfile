FROM python:3.7-slim
COPY . /app
WORKDIR /app
EXPOSE 8000
ENV FLASK_APP=server.py
RUN pip install -r requirements.txt
CMD [ "flask", "run", "--host=0.0.0.0", "--port=8000"]
