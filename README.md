# chat_app_challenge README

## 1. Project Overview

This is a functional real-time chat application designed to facilitate instant messaging between users. It provides a simple and intuitive interface for sending and receiving messages.

this app is built using flutter and supabase for the backend, the state management is handled using riverpod.
in the architecture of the app, we have the following layers:

- presentation layer: this is the layer that handles the user interface and the user interaction.
- domain layer: this is the layer that handles the business logic.
- infrastructure layer: this is the layer that handles the data access.

## 2. Installation

Follow these steps to get the project installed on your local machine:

Clone the repository:
Open your terminal or command prompt and run the following command:

git clone https://github.com/jbaptistadev/chat_app_challenge.git

Navigate into the project directory:

cd chat_app_challenge

Install dependencies:
Once inside the project directory, install all required dependencies:

flutter pub get

## 3. Configuration

the app uses supabase for the backend, you need to create a supabase project and add the following environment variables to your .env file:

```
SUPABASE_URL=supabase_url
SUPABASE_ANON_KEY=supabase_anon_key
```

you have an example of the .env file in the .env-template file.

## 4. Running the Application

After successful installation, you can launch the application:

Start the application:

flutter run or flutter run -d <device_id>

Access the application:

Open the application on your device or emulator.

## 5. User Registration

To use the chat features, you first need to register an account:

Navigate to the registration page:
Look for a "Sign Up" or "Register" link on the homepage or login screen and click it.

Fill in your details:
You will typically be prompted to enter:

A unique Username

Your Email Address

A strong Password

When you click on the register button, you will be prompted to confirm your email address in your email inbox

## 6. Using the Chat App

Once you've registered and logged in, you can start using the chat features:

Navigate to chat rooms/contacts:

You will typically see a list of available chat rooms, private message contacts, or a general lobby.

Send messages:

Select a chat room or contact.

Type your message into the input field at the bottom of the chat interface.

Press Enter or click the "Send" button to dispatch your message.

Receive messages:
Messages from other users in the same chat or direct conversation will appear automatically in real-time.
