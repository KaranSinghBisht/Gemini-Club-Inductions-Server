#!/bin/bash

setQuiz() {
  if [[ $PWD == /home/core/mentors/* ]]; then
    # Create the quiz directory if it doesn't exist
    quiz_dir="/home/core/mentors/quiz"
    mkdir -p "$quiz_dir"

    echo "Enter quiz questions (press Enter on a blank line to finish):"
    local questions=()
    while IFS= read -r -p "Question $((${#questions[@]} + 1)): " question && [[ $question ]]; do
      questions+=("$question")
    done

    # Save questions to a file
    printf "%s\n" "${questions[@]}" > "$quiz_dir/quiz_questions.txt"

    echo "Quiz questions set successfully."

  elif [[ $PWD == /home/core/mentees/* ]]; then
    quiz_file="/home/core/mentors/quiz/quiz_questions.txt"
    if [[ ! -f "$quiz_file" ]]; then
      echo "No quiz available."
      return
    fi

    echo "New Quiz Available!"
    echo "Quiz Questions:"
    cat "$quiz_file"

    # Prompt mentee to answer each question
    echo "Answer the following questions:"
    local question_number=1
    answer_file="$HOME/quiz_answers.txt"
    while IFS= read -r question; do
      read -p "Answer for Question $question_number: " answer
      echo "Question $question_number: $answer" >> "$answer_file"
      ((question_number++))
    done < "$quiz_file"

    echo "Quiz answers saved successfully."
  else
    echo "Error: Unknown user type." >&2
  fi
}

setQuiz