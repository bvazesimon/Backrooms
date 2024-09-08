using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MenuManager : MonoBehaviour
{
    public GameObject image1, image2; 
    // Start is called before the first frame update
    void Start()
    {
        
    }
    public void selectLevel(int index)
    {
        SceneManager.LoadScene(index);

    }
     
    // Update is called once per frame
    void Update()
    {
        
    }
}
