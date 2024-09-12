document.addEventListener('DOMContentLoaded', () => {
    const contactForm = document.getElementById('contact-form');
    const feedbackImage = document.getElementById('feedback-image');
    
    contactForm.addEventListener('submit', function(event) {
        event.preventDefault();
        
        
        feedbackImage.src = 'images/message_delivered.jpg';
        
       
        contactForm.reset();
    });
});

const apiKey = '95a02534dc83bfb7d67405dc2feb9b89';
let isCelsius = true;
let currentCity = '';
let chartTemperature, chartPrecipitation, chartWind;
let currentLanguage = 'en';

document.getElementById('search-btn').addEventListener('click', () => {
    const city = document.getElementById('city-search').value;
    currentCity = city;
    getWeather(city);
    getForecast(city);
});

document.getElementById('toggle-temp').addEventListener('click', () => {
    isCelsius = !isCelsius;
    if (currentCity) {
        getWeather(currentCity);
        getForecast(currentCity);
    }
    document.getElementById('toggle-temp').innerText = isCelsius ? '°C/°F' : '°C/°F';
});

document.getElementById('toggle-lang').addEventListener('click', () => {
    currentLanguage = currentLanguage === 'en' ? 'de' : 'en';
    if (currentCity) {
        getWeather(currentCity);
        getForecast(currentCity);
    }
    document.getElementById('toggle-lang').innerText = currentLanguage === 'en' ? 'DE/EN' : 'DE/EN';
    translatePage(currentLanguage);
});

document.querySelectorAll('a[data-toggle="tab"]').forEach(tab => {
    tab.addEventListener('shown.bs.tab', event => {
        const target = event.target.getAttribute('href').substring(1);
        switch (target) {
            case 'temperature':
                chartTemperature.update();
                break;
            case 'precipitation':
                chartPrecipitation.update();
                break;
            case 'wind':
                chartWind.update();
                break;
        }
    });
});

function getWeather(city) {
    console.log(`Fetching weather data for: ${city}`);
    fetch(`https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${apiKey}&units=${isCelsius ? 'metric' : 'imperial'}&lang=${currentLanguage}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            console.log(data);
            document.getElementById('city').innerText = data.name;
            document.getElementById('temperature').innerText = `${data.main.temp}°${isCelsius ? 'C' : 'F'}`;
            document.getElementById('real-feel').innerText = `RealFeel® ${data.main.feels_like}°${isCelsius ? 'C' : 'F'}`;
            document.getElementById('condition').innerText = data.weather[0].description;
            document.getElementById('wind-speed').innerText = `Wind: ${data.wind.speed} ${isCelsius ? 'm/s' : 'mph'}`;
            document.getElementById('wind-gust').innerText = `Wind Gusts: ${data.wind.gust || '--'} ${isCelsius ? 'm/s' : 'mph'}`;
            document.getElementById('humidity').innerText = `Humidity: ${data.main.humidity}%`;
            document.getElementById('air-quality').innerText = `Air Quality: --`;
            document.getElementById('weather-icon').src = `icons/${getLocalIcon(data.weather[0].main)}`;
            updateBackground(data.weather[0].main);
        })
        .catch(error => console.error('Error:', error));
}

function getForecast(city) {
    console.log(`Fetching forecast data for: ${city}`);
    fetch(`https://api.openweathermap.org/data/2.5/forecast?q=${city}&appid=${apiKey}&units=${isCelsius ? 'metric' : 'imperial'}&lang=${currentLanguage}`)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok ' + response.statusText);
            }
            return response.json();
        })
        .then(data => {
            console.log(data);

            const forecastDetailsTemperature = document.getElementById('forecast-details-temperature');
            const forecastDetailsPrecipitation = document.getElementById('forecast-details-precipitation');
            const forecastDetailsWind = document.getElementById('forecast-details-wind');
            forecastDetailsTemperature.innerHTML = '';
            forecastDetailsPrecipitation.innerHTML = '';
            forecastDetailsWind.innerHTML = '';

            const labels = [];
            const temperatures = [];
            const precipitations = [];
            const winds = [];

            const dailyData = {};
            data.list.forEach(item => {
                const date = new Date(item.dt * 1000).toLocaleDateString('en-US', { weekday: 'short', day: 'numeric', month: 'short' });
                if (!dailyData[date]) {
                    dailyData[date] = [];
                }
                dailyData[date].push(item);
            });

            const uniqueDays = Object.keys(dailyData).slice(0, 7);

            uniqueDays.forEach(date => {
                const items = dailyData[date];
                const temp = items.reduce((sum, item) => sum + item.main.temp, 0) / items.length;
                const precip = items.reduce((sum, item) => sum + (item.rain ? item.rain['3h'] || 0 : 0), 0);
                const wind = items.reduce((sum, item) => sum + item.wind.speed, 0) / items.length;
                const description = items[0].weather[0].description;
                const icon = getLocalIcon(items[0].weather[0].main);

                labels.push(date);
                temperatures.push(temp.toFixed(1));
                precipitations.push(precip.toFixed(1));
                winds.push(wind.toFixed(1));

                const forecastDayTemperature = document.createElement('div');
                forecastDayTemperature.className = 'forecast-day';
                forecastDayTemperature.innerHTML = `
                    <div class="forecast-date">${date}</div>
                    <div class="forecast-temp">Temp: ${temp.toFixed(1)}°${isCelsius ? 'C' : 'F'}</div>
                    <div class="forecast-desc">
                        <img src="icons/${icon}" alt="${description}">
                        ${description}
                    </div>
                `;
                forecastDetailsTemperature.appendChild(forecastDayTemperature);

                const forecastDayPrecipitation = document.createElement('div');
                forecastDayPrecipitation.className = 'forecast-day';
                forecastDayPrecipitation.innerHTML = `
                    <div class="forecast-date">${date}</div>
                    <div class="forecast-precip">Precip: ${precip.toFixed(1)} mm</div>
                    <div class="forecast-desc">
                        <img src="icons/${icon}" alt="${description}">
                        ${description}
                    </div>
                `;
                forecastDetailsPrecipitation.appendChild(forecastDayPrecipitation);

                const forecastDayWind = document.createElement('div');
                forecastDayWind.className = 'forecast-day';
                forecastDayWind.innerHTML = `
                    <div class="forecast-date">${date}</div>
                    <div class="forecast-wind">Wind: ${wind.toFixed(1)} ${isCelsius ? 'm/s' : 'mph'}</div>
                    <div class="forecast-desc">
                        <img src="icons/${icon}" alt="${description}">
                        ${description}
                    </div>
                `;
                forecastDetailsWind.appendChild(forecastDayWind);
            });

            chartTemperature = renderChart('forecast-chart-temperature', labels, temperatures, 'Temperature', chartTemperature);
            chartPrecipitation = renderChart('forecast-chart-precipitation', labels, precipitations, 'Precipitation', chartPrecipitation);
            chartWind = renderChart('forecast-chart-wind', labels, winds, 'Wind Speed', chartWind);
        })
        .catch(error => console.error('Error:', error));
}

function getCurrentLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else {
        console.error("Geolocation is not supported by this browser.");
    }
}

function showPosition(position) {
    const lat = position.coords.latitude;
    const lon = position.coords.longitude;
    fetch(`https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=${isCelsius ? 'metric' : 'imperial'}&lang=${currentLanguage}`)
        .then(response => response.json())
        .then(data => {
            document.getElementById('city').innerText = data.name;
            document.getElementById('temperature').innerText = `${data.main.temp}°${isCelsius ? 'C' : 'F'}`;
            document.getElementById('real-feel').innerText = `RealFeel® ${data.main.feels_like}°${isCelsius ? 'C' : 'F'}`;
            document.getElementById('condition').innerText = data.weather[0].description;
            document.getElementById('wind-speed').innerText = `Wind: ${data.wind.speed} ${isCelsius ? 'm/s' : 'mph'}`;
            document.getElementById('wind-gust').innerText = `Wind Gusts: ${data.wind.gust || '--'} ${isCelsius ? 'm/s' : 'mph'}`;
            document.getElementById('humidity').innerText = `Humidity: ${data.main.humidity}%`;
            document.getElementById('air-quality').innerText = `Air Quality: --`;
            document.getElementById('weather-icon').src = `icons/${getLocalIcon(data.weather[0].main)}`;
            updateBackground(data.weather[0].main);
            currentCity = data.name;
            getForecast(data.name);
        })
        .catch(error => console.error('Error:', error));
}

getCurrentLocation();

function updateBackground(weatherCondition) {
    const weatherContainer = document.getElementById('weather-container');
    switch (weatherCondition.toLowerCase()) {
        case 'clear':
            weatherContainer.style.backgroundImage = "url('clear.jpg')";
            break;
        case 'clouds':
            weatherContainer.style.backgroundImage = "url('clouds.jpg')";
            break;
        case 'rain':
            weatherContainer.style.backgroundImage = "url('rain.jpg')";
            break;
        case 'snow':
            weatherContainer.style.backgroundImage = "url('snow.jpg')";
            break;
        default:
            weatherContainer.style.backgroundImage = "url('default.jpg')";
            break;
    }
}

function renderChart(canvasId, labels, data, label, chartInstance) {
    const ctx = document.getElementById(canvasId).getContext('2d');
    if (chartInstance) {
        chartInstance.destroy();
    }
    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: label,
                data: data,
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 2,
                fill: true,
                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            scales: {
                x: {
                    type: 'category',
                    time: {
                        unit: 'day'
                    }
                },
                y: {
                    beginAtZero: true
                }
            },
            plugins: {
                legend: {
                    display: true
                },
                tooltip: {
                    enabled: true
                }
            },
            elements: {
                line: {
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 2,
                    fill: true,
                    backgroundColor: 'rgba(75, 192, 192, 0.2)'
                },
                point: {
                    radius: 3,
                    backgroundColor: 'rgba(75, 192, 192, 1)'
                }
            }
        }
    });
}

function getLocalIcon(weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
        case 'clear':
            return 'clear.png';
        case 'clouds':
            return 'cloudy.png';
        case 'rain':
            return 'rainy.png';
        case 'snow':
            return 'snowy.png';
        case 'thunderstorm':
            return 'thunderstorm.png';
        default:
            return 'cloudy.png'; 
    }
}

function translatePage(language) {
    const translations = {
        en: {
            citySearchPlaceholder: 'Enter city name',
            searchBtn: 'Search',
            tempToggle: '°C/°F',
            langToggle: 'DE/EN',
            temperatureTab: 'Temperature',
            precipitationTab: 'Precipitation',
            windTab: 'Wind',
            forecastTitle: '7-Day Forecast'
        },
        de: {
            citySearchPlaceholder: 'Stadtnamen eingeben',
            searchBtn: 'Suchen',
            tempToggle: '°C/°F',
            langToggle: 'DE/EN',
            temperatureTab: 'Temperatur',
            precipitationTab: 'Niederschlag',
            windTab: 'Wind',
            forecastTitle: '7-Tage-Vorhersage'
        }
    };

    const translation = translations[language];

    document.getElementById('city-search').placeholder = translation.citySearchPlaceholder;
    document.getElementById('search-btn').innerText = translation.searchBtn;
    document.getElementById('toggle-temp').innerText = translation.tempToggle;
    document.getElementById('toggle-lang').innerText = translation.langToggle;
    document.getElementById('temperature-tab').innerText = translation.temperatureTab;
    document.getElementById('precipitation-tab').innerText = translation.precipitationTab;
    document.getElementById('wind-tab').innerText = translation.windTab;
    document.querySelector('#forecast-container h3').innerText = translation.forecastTitle;
}
