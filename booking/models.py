from django.db import models
from django.contrib.auth.models import User

# Salon ki services (jaise Haircut, Spa)
class Service(models.Model):
    name = models.CharField(max_length=100)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    duration_minutes = models.IntegerField()

    def __str__(self):
        return self.name

# Appointment ki details
class Appointment(models.Model):
    customer = models.ForeignKey(User, on_delete=models.CASCADE)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    date = models.DateField()
    time_slot = models.TimeField()
    status = models.CharField(max_length=20, default='Pending')

    def __str__(self):
        return f"{self.customer.username} - {self.service.name}"