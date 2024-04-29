using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class CreditsInformation : MonoBehaviour
{
    [SerializeField] TextMeshProUGUI creditText;
    [SerializeField] string[] creditsString;
    IEnumerator currentCor;

    [SerializeField] GameObject creditsTitle;

    // Start is called before the first frame update
    void Start()
    {
        currentCor = CreditsCor();
        StartCoroutine(currentCor);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R))
        {
            if (currentCor != null)
            {
                StopCoroutine(currentCor);
            }
            currentCor = CreditsCor();
            StartCoroutine(currentCor);
        }
    }
    float speed;
    IEnumerator CreditsCor()
    {
        creditsTitle.SetActive(true);
        //creditText.text = "";
        for (int i = 0; i < creditsString.Length; i++)
        {
            creditText.text = "";
            for (int j = 0; j < creditsString[i].Length; j++)
            {
                creditText.text += creditsString[i][j];
                yield return new WaitForSeconds(0.05f);
            }
            if (i <= 2 || i == creditsString.Length-1)
            {
                speed = 5;
            }
            else
            {
                speed = 2;
            }
            yield return new WaitForSeconds(speed);
        }
        creditsTitle.SetActive(false);
        creditText.text = "";
        //creditText.text = creditsString[creditsString.Length-1];
    }
}
