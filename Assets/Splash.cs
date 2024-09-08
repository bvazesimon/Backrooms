using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Splash : MonoBehaviour
{

    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(loading());
    }
    IEnumerator loading()
    {

           yield return new WaitForSeconds(1.3f);
        SceneManager.LoadScene(1);
    }
    // Update is called once per frame
    void Update()
    {
        
    }
}
