using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

using LightDev;

namespace TPSShooter
{
  // This class controlls state of the game.
  // It can stop/resume/finish the game 
  //        (when the game is stopped/resumed/finished this class notifies other GameObjects that subscribes to events).
  // It can also download Menu scene and Play scene.
  public class GameManager : MonoBehaviour
  {
    public static bool IsGamePaused { get; private set; }
    public static bool IsGameFinished { get; private set; }
        public GameObject[] gameObjectsToCheck;

        private void Awake()
    {
      IsGamePaused = false;
      IsGameFinished = false;

      Events.GamePauseRequested += OnGamePauseRequested;
      Events.GameResumeRequested += OnGameResumeRequested;
      Events.GameReplayRequested += OnGameReplayRequested;
      Events.GameLoadHomeSceneRequested += OnGameLoadHomeSceneRequested;
      Events.PlayerDied += OnPlayerDied;
    }
        void Update()
        {
            // Check if any GameObject in the array has an enabled CharacterController
            bool anyCharacterControllerEnabled = false;

            foreach (GameObject obj in gameObjectsToCheck)
            {
                if (obj != null) { 
                CharacterController characterController = obj.GetComponent<CharacterController>();

                if (characterController != null && characterController.enabled)
                {
                    anyCharacterControllerEnabled = true;
                    break;
                }
                }
            }

            // Perform an action if none of the GameObjects have an enabled CharacterController
            if (!anyCharacterControllerEnabled)
            {
                FinishGame();
            }
        }
        private void OnDestroy()
    {
      Events.GamePauseRequested -= OnGamePauseRequested;
      Events.GameResumeRequested -= OnGameResumeRequested;
      Events.GameReplayRequested -= OnGameReplayRequested;
      Events.GameLoadHomeSceneRequested -= OnGameLoadHomeSceneRequested;
      Events.PlayerDied -= OnPlayerDied;
    }

    private void OnGamePauseRequested()
    {
      if (!IsGamePaused)
      {
        PauseGame();
      }
    }

    private void OnGameResumeRequested()
    {
      if (IsGamePaused)
      {
        ResumeGame();
      }
    }

    private void OnGameReplayRequested()
    {
      Replay();
    }

    private void OnGameLoadHomeSceneRequested()
    {
      LoadHomeScene();
    }

    private void OnPlayerDied()
    {
      if (IsGameFinished) return;

      FinishGame();
    }

    private void PauseGame()
    {
      if (IsGameFinished) return;

      Time.timeScale = 0;

      IsGamePaused = true;
      Events.GamePaused.Call();
    }

    private void ResumeGame()
    {
      Time.timeScale = 1;

      IsGamePaused = false;
      Events.GameResumed.Call();
    }

    private void FinishGame()
    {
      IsGameFinished = true;
      Events.GameFinished.Call();
    }

    private void Replay()
    {
      Time.timeScale = 1;
      Events.GameReplay.Call();
      StartCoroutine(LoadScene(SceneManager.GetActiveScene().buildIndex));
    }

    private void LoadHomeScene()
    {
      Time.timeScale = 1f;
      Events.GameLoadHomeScene.Call();
      StartCoroutine(LoadScene(0));
    }

    private IEnumerator LoadScene(int sceneIndex)
    {
      Events.SceneUnload.Call();
      yield return new WaitForSeconds(0.1f);

      AsyncOperation operation = SceneManager.LoadSceneAsync(sceneIndex);
      operation.allowSceneActivation = false;

      while (!operation.isDone)
      {
        if (operation.progress >= 0.9f)
        {
          operation.allowSceneActivation = true;
        }

        yield return null;
      }
    }
  }
     
}
