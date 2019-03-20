# Translater

## Features

The app features three tabs:

- Translate: Find german translations of english words or vice versa. Add word pairs to the vocabulary.
- Vocabulary: Browse and manage your vocabulary.
- Metrics: See how your vocabulary grows and measure your retention rate.

## Installation

This is a Flutter project. To build and run the app, Flutter and iOS or Android tooling is required (https://flutter.io/docs/get-started/install).

## Sample Data

The app provides a sample vocabulary which can loaded at launch instead of the actually persisted data. This mechanism is controlled by the flag `_useSampleData` in the [VocabularyService](https://github.com/ernesto-elsaesser/translater/blob/master/lib/services/VocabularyService.dart#L18)