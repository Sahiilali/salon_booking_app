from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth import login, logout # Dono yahan add kar diye hain
from django.contrib.auth.decorators import login_required
from .models import Service, Appointment
from .form import AppointmentForm, SignUpForm # Make sure file name is forms.py

# 1. Home Page View
def home(request):
    services = Service.objects.all()
    return render(request, 'booking/home.html', {'services': services})

# 2. Signup View (Modern & Clean)
def signup(request):
    if request.method == 'POST':
        form = SignUpForm(request.POST)
        if form.is_valid():
            user = form.save()
            login(request, user)
            return redirect('home')
    else:
        form = SignUpForm()
    return render(request, 'registration/signup.html', {'form': form})

# 3. Booking View (Updated with Details for Success Page)
@login_required
def book_appointment(request, service_id):
    service = get_object_or_404(Service, id=service_id)
    if request.method == 'POST':
        form = AppointmentForm(request.POST)
        if form.is_valid():
            appointment = form.save(commit=False)
            appointment.service = service
            appointment.customer = request.user
            appointment.save()
            
            # Success page par details dikhane ke liye data bhej rahe hain
            return render(request, 'booking/success.html', {
                'service_name': service.name,
                'appointment': appointment
            })
    else:
        form = AppointmentForm()
    return render(request, 'booking/book.html', {'form': form, 'service': service})

# 4. My Bookings View
@login_required
def my_bookings(request):
    # Sirf logged-in user ki bookings dikhayega
    appointments = Appointment.objects.filter(customer=request.user).order_by('-date')
    return render(request, 'booking/my_bookings.html', {'appointments': appointments})

# 5. Logout View (Fixed Indentation)
def logout_view(request):
    logout(request)
    return redirect('home')