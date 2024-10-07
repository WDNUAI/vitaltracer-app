#include <OneWire.h>
#include <DallasTemperature.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include <vector>

// Define the pin for the OneWire bus to communicate with the temperature sensor.
const int oneWireBus = 4;
OneWire oneWire(oneWireBus);
DallasTemperature sensors(&oneWire); // Initialize the DallasTemperature library for the sensor.

// UUIDs for the BLE services and characteristics.
#define TEMPERATURE_SERVICE_UUID       BLEUUID((uint16_t)0x1809)
#define TEMPERATURE_CHARACTERISTIC_UUID BLEUUID((uint16_t)0x2A1C)
#define ECG_SERVICE_UUID               BLEUUID((uint16_t)0x181D)
#define ECG_CHARACTERISTIC_UUID        BLEUUID((uint16_t)0x2A37)
#define ACTIVITY_SERVICE_UUID         BLEUUID((uint16_t)0x1814)
#define ACTIVITY_CHARACTERISTIC_UUID  BLEUUID((uint16_t)0x2A53)
#define SPO2_SERVICE_UUID               BLEUUID((uint16_t)0x1822)
#define SPO2_CHARACTERISTIC_UUID        BLEUUID((uint16_t)0x2A5E)

// Global BLE server and characteristics.
BLEServer* pServer = NULL;
BLECharacteristic* pTemperatureCharacteristic = NULL;
BLECharacteristic* pEcgCharacteristic = NULL;
BLECharacteristic* pActivityCharacteristic = NULL;
BLECharacteristic* pSpO2Characteristic = NULL;
bool deviceConnected = false; // Flag to track if a client is connected.

// ECG and activity data batches for sending in bulk.
std::vector<int16_t> ecgBatch; // Vector to store ECG data batch.
const int batchSize = 50; // Define the size of the ECG data batch (50 samples).
const int ECG_SAMPLE_RATE = 250; // Sample rate for ECG data (250 Hz).
const float ECG_FREQUENCY = 1.0; // Frequency of the simulated ECG waveform (1 Hz).
const float ECG_AMPLITUDE = 512; // Amplitude of the simulated ECG waveform.
const float ECG_OFFSET = 512; // Offset to center the simulated ECG waveform.
int ecgIndex = 0; // Index to track ECG data points.

bool activityState = false; // Current activity state (true = active, false = inactive).
unsigned long lastActivityChangeTime = 0; // Timestamp for the last activity state change.
const unsigned long activityChangeInterval = 5000; // Time interval for toggling activity state (5 seconds).

std::vector<uint8_t> activityBatch;  // Vector to store activity data batch.
const int activityBatchSize = 20;    // Define the size of the activity data batch (20 samples).

// Callbacks for BLE server connections.
class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    deviceConnected = true; // Set deviceConnected flag to true when a client connects.
    Serial.println("Client connected");
  };

  void onDisconnect(BLEServer* pServer) {
    deviceConnected = false; // Set deviceConnected flag to false when a client disconnects.
    Serial.println("Client disconnected");
    BLEDevice::startAdvertising(); // Start advertising again after disconnection.
  }
};

// Function to generate a simulated ECG signal.
int16_t generateSimulatedECG(unsigned long timeMs) {
  float timeSec = timeMs / 1000.0; // Convert milliseconds to seconds.
  
  // Normalize the time to repeat every second (simulating 1 Hz frequency).
  float normalizedTime = fmod(timeSec, 1.0);

  // Initialize the ECG signal value.
  int16_t ecgValue = ECG_OFFSET;

  // Simulate the ECG waveform's P-wave, QRS complex, and T-wave.

  // P-wave: A small upward deflection before the QRS complex.
  if (normalizedTime >= 0.0 && normalizedTime < 0.1) {
    ecgValue += ECG_AMPLITUDE * 0.1 * sin(2 * M_PI * 5 * normalizedTime);
  }
  // QRS complex: A sharp peak and quick deflection representing the heartbeat.
  else if (normalizedTime >= 0.1 && normalizedTime < 0.2) {
    ecgValue -= ECG_AMPLITUDE * 0.5 * sin(2 * M_PI * 25 * (normalizedTime - 0.1));
  }
  // T-wave: A broader, smaller upward deflection after the QRS complex.
  else if (normalizedTime >= 0.3 && normalizedTime < 0.4) {
    ecgValue += ECG_AMPLITUDE * 0.2 * sin(2 * M_PI * 8 * (normalizedTime - 0.3));
  }

  return ecgValue; // Return the generated ECG value.
}

// Function to generate simulated activity data (binary state for active/inactive).
bool generateSimulatedActivity() {
  unsigned long currentTime = millis(); // Get the current time in milliseconds.

  // Toggle activity state every 5 seconds.
  if (currentTime - lastActivityChangeTime >= activityChangeInterval) {
    activityState = !activityState; // Toggle activity state (active/inactive).
    lastActivityChangeTime = currentTime; // Update the last activity change time.
  }

  return activityState; // Return the current activity state.
}

// Function to generate a simulated temperature value as a sine wave.
float generateSimulatedTemperature(unsigned long timeMs) {
  float timeSec = timeMs / 1000.0; // Convert milliseconds to seconds.
  float frequency = 0.01; // Frequency of the sine wave (0.01 Hz = one cycle every 100 seconds).
  float amplitude = 10.0; // Amplitude of the sine wave (±10°C).
  float offset = 25.0; // Offset of the sine wave (centered around 25°C).

  return offset + amplitude * sin(2 * M_PI * frequency * timeSec); // Calculate and return the sine wave value.
}

// Function to generate a random SpO2 value.
uint8_t generateRandomSpO2() {
  return random(90, 96); // Generate and return a random SpO2 value between 90% and 95%.
}

// Setup function to initialize BLE services, characteristics, and start advertising.
void setup() {
  Serial.begin(115200); // Start the serial communication for debugging.
  sensors.begin(); // Initialize the temperature sensor.

  BLEDevice::init("ESP32 Wearable"); // Initialize the BLE device with the name "ESP32 Wearable".
  pServer = BLEDevice::createServer(); // Create the BLE server.
  pServer->setCallbacks(new MyServerCallbacks()); // Set the BLE server callbacks.

  // Setup temperature BLE service and characteristic.
  BLEService* pTemperatureService = pServer->createService(TEMPERATURE_SERVICE_UUID);
  pTemperatureCharacteristic = pTemperatureService->createCharacteristic(
    TEMPERATURE_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pTemperatureCharacteristic->addDescriptor(new BLE2902()); // Add descriptor for notifications.
  pTemperatureService->start(); // Start the temperature service.

  // Setup ECG BLE service and characteristic.
  BLEService* pEcgService = pServer->createService(ECG_SERVICE_UUID);
  pEcgCharacteristic = pEcgService->createCharacteristic(
    ECG_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pEcgCharacteristic->addDescriptor(new BLE2902()); // Add descriptor for notifications.
  pEcgService->start(); // Start the ECG service.

  // Setup activity BLE service and characteristic.
  BLEService* pActivityService = pServer->createService(ACTIVITY_SERVICE_UUID);
  pActivityCharacteristic = pActivityService->createCharacteristic(
    ACTIVITY_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pActivityCharacteristic->addDescriptor(new BLE2902()); // Add descriptor for notifications.
  pActivityService->start(); // Start the activity service.

  // Setup SpO2 BLE service and characteristic.
  BLEService* pSpO2Service = pServer->createService(SPO2_SERVICE_UUID);
  pSpO2Characteristic = pSpO2Service->createCharacteristic(
    SPO2_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY
  );
  pSpO2Characteristic->addDescriptor(new BLE2902()); // Add descriptor for notifications.
  pSpO2Service->start(); // Start the SpO2 service.

  // Start advertising BLE services.
  BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(TEMPERATURE_SERVICE_UUID);
  pAdvertising->addServiceUUID(ECG_SERVICE_UUID);
  pAdvertising->addServiceUUID(ACTIVITY_SERVICE_UUID);
  pAdvertising->addServiceUUID(SPO2_SERVICE_UUID);
  pAdvertising->setScanResponse(true); // Set scan response.
  pAdvertising->setMinPreferred(0x06); // Set preferred connection interval.
  pAdvertising->setMinPreferred(0x12); // Set preferred connection interval.
  BLEDevice::startAdvertising(); // Start BLE advertising.
  Serial.println("Advertising started");

  Serial.println("Device ready");
}

// Main loop to send sensor data if a client is connected.
void loop() {
  if (deviceConnected) { // Check if a BLE client is connected.
    static unsigned long lastTemperatureTime = 0;
    static unsigned long lastEcgTime = 0;
    static unsigned long lastActivityTime = 0;
    static unsigned long lastSpO2Time = 0;
    unsigned long currentTime = millis(); // Get the current time.

    // Send temperature data every 30 seconds.
    if (currentTime - lastTemperatureTime >= 30000) {
      lastTemperatureTime = currentTime;
      float temperatureC = generateSimulatedTemperature(currentTime); // Generate simulated temperature.
      int16_t temperatureInt = (int16_t)(temperatureC * 100);
      uint8_t tempData[2];
      tempData[0] = (uint8_t)(temperatureInt & 0xFF);
      tempData[1] = (uint8_t)((temperatureInt >> 8) & 0xFF);
      pTemperatureCharacteristic->setValue(tempData, 2); // Set the temperature value.
      pTemperatureCharacteristic->notify(); // Notify the connected client.
      Serial.println("Temperature notified: " + String(temperatureC));
    }

    // Send ECG data every 200 milliseconds (50 samples per batch).
    if (currentTime - lastEcgTime >= 200) {
      lastEcgTime = currentTime; // Update the last ECG time.
      for (int i = 0; i < batchSize; i++) {
        int16_t ecgValue = generateSimulatedECG(currentTime + (i * 4)); // Generate simulated ECG data.
        ecgBatch.push_back(ecgValue); // Add ECG data to the batch.
      }

      if (ecgBatch.size() >= batchSize) {
        // Prepare ECG data for transmission (100 bytes = 50 samples x 2 bytes per sample).
        uint8_t ecgData[batchSize * 2]; // Array to hold ECG data bytes.
        for (int i = 0; i < batchSize; i++) {
          ecgData[i * 2] = (uint8_t)(ecgBatch[i] & 0xFF); // Lower byte of ECG value.
          ecgData[i * 2 + 1] = (uint8_t)((ecgBatch[i] >> 8) & 0xFF); // Upper byte of ECG value.
        }
        pEcgCharacteristic->setValue(ecgData, batchSize * 2); // Set the ECG data.
        pEcgCharacteristic->notify(); // Notify the connected client.
        ecgBatch.clear(); // Clear the batch after sending.
      }
    }

    // Send activity data every 2 seconds (20 samples per batch).
    if (currentTime - lastActivityTime >= 2000) {
      lastActivityTime = currentTime;

      for (int i = 0; i < activityBatchSize; i++) {
        bool activityValue = generateSimulatedActivity();  // Generate simulated activity.
        activityBatch.push_back(activityValue ? 1 : 0);    // Add activity state (0 or 1) to the batch.
      }

      if (activityBatch.size() >= activityBatchSize) {
        uint8_t activityData[activityBatchSize];  // Array to hold activity data bytes.
        for (int i = 0; i < activityBatchSize; i++) {
          activityData[i] = activityBatch[i];  // Copy activity data to the byte array.
        }
        pActivityCharacteristic->setValue(activityData, activityBatchSize);  // Set the activity data.
        pActivityCharacteristic->notify();  // Notify the connected client.
        activityBatch.clear();  // Clear the batch after sending.

        Serial.println("Sending activity batch notification...");
      }
    }

    // Send SpO2 data every 10 seconds.
    if (currentTime - lastSpO2Time >= 10000) {
      lastSpO2Time = currentTime;
      uint8_t spO2Value = generateRandomSpO2(); // Generate random SpO2 value.
      pSpO2Characteristic->setValue(&spO2Value, 1); // Set the SpO2 value.
      pSpO2Characteristic->notify(); // Notify the connected client.
      Serial.println("SpO2 notified: " + String(spO2Value) + "%");
    }
  }

  delay(1); // Short delay to prevent overwhelming the microcontroller.
}
