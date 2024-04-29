using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreditsFloor : MonoBehaviour
{
    [SerializeField] GameObject player;
    private void Start()
    {
        player = GameObject.FindGameObjectWithTag("Player");
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            Debug.Log("collided with player");
            StartCoroutine(LateMove());
        }
    }

    IEnumerator LateMove()
    {
        player.GetComponent<PlayerManager>().enabled = false;
        player.transform.position = new Vector3(player.transform.position.x, player.transform.position.y + 3, player.transform.position.z);
        yield return new WaitForSeconds(0.25f);
        player.transform.position = new Vector3(player.transform.position.x, player.transform.position.y + 3, player.transform.position.z);
        player.GetComponent<PlayerManager>().enabled = true;
    }
}
