FROM python:3.14-slim


RUN python -m venv /venv 
ENV PATH="/venv/bin:$PATH" 


COPY requirements.txt /tmp/requirements.txt  
RUN pip install -r /tmp/requirements.txt 

RUN pip install "django<6" gunicorn whitenoise


COPY src /src


WORKDIR /src

RUN python manage.py collectstatic

ENV DJANGO_DEBUG_FALSE=1

RUN adduser --uid 1234 nonroot  
USER nonroot 


#CMD ["gunicorn","sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8888"]

CMD ["gunicorn", "--bind", ":8888", "superlists.wsgi:application"]