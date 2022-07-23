FROM python:3.10.5-bullseye

WORKDIR /app
COPY ./requirements.txt /app/ 

RUN pip install -r requirements.txt

COPY . /app/

EXPOSE 5000/tcp

CMD flask run -h 0.0.0.0 -p 5000