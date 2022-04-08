FROM python:3.7-alpine

RUN apk update
RUN apk add python3 python3-dev py3-pip nginx

RUN pip install pipenv

ADD . /flask-deploy

WORKDIR /flask-deploy

RUN pipenv install --system --skip-lock

RUN pip install gunicorn[gevent]
RUN pip install flower

EXPOSE 8000

#CMD ["gunicorn", "-w", "3", "--bind",  ":8000", "wsgi:app"]

CMD gunicorn --worker-class gevent --workers 3 --bind 0.0.0.0:8000 wsgi:app --max-requests 10000 --timeout 5 --keep-alive 5 --log-level info

#CMD python app.py
