using UnityEngine;
using System.Collections;

public class Centaur_ctrl : MonoBehaviour {
	
	
	private Animator anim;
	private CharacterController controller;
	private int battle_state = 0;
	public float speed = 6.0f;
	public float runSpeed = 3.0f;
	public float turnSpeed = 60.0f;
	public float gravity = 20.0f;
	private Vector3 moveDirection = Vector3.zero;
	private float w_sp = 0.0f;
	private float r_sp = 0.0f;
	private bool armed = true;
	
	// Use this for initialization
	void Start () 
	{						
		anim = GetComponent<Animator>();
		controller = GetComponent<CharacterController> ();
		w_sp = speed; //read walk speed
		r_sp = runSpeed; //read run speed
		battle_state = 0;
		runSpeed = 1;

	}
	
	// Update is called once per frame
	void Update () 
	{		
		if (Input.GetKey ("1"))  // turn to still state
		{ 		
			anim.SetInteger ("battle", 0);
			battle_state = 0;
			runSpeed = 1;
		}
		if (Input.GetKeyUp ("q")) // Disarm
		{ 
		//	if (battle_state!=1)
		//	{
				if (armed) 
				{
					anim.SetBool ("armed", true);
				} 
				if (!armed)
				{
					anim.SetBool ("armed", false);
					anim.SetInteger ("battle", 0);
					battle_state =0;
					runSpeed =1;
				}
				armed=!armed;
		//	}


		}
		if (Input.GetKey ("2")) // turn to battle state
		{ 
			anim.SetInteger ("battle", 1);
			anim.SetBool ("armed", true);
			armed=true;
			battle_state = 1;
			runSpeed = r_sp;
		}

			
		if (Input.GetKey ("up")) 
		{
			anim.SetInteger ("moving", 1);//walk/run/moving
		}
		else 
			{
				anim.SetInteger ("moving", 0);
			}


		if (Input.GetKey ("down")) //walkback
		{
			anim.SetInteger ("moving", 12);
			runSpeed = 1;
		}
		if (Input.GetKeyUp ("down")) 
		{
			if (battle_state == 0) runSpeed = 1;
			else if (battle_state >0) runSpeed = r_sp;
		}
	
		if (Input.GetMouseButtonDown (0)) { // attack1
			anim.SetInteger ("moving", 2);
		}
		if (Input.GetMouseButtonDown (1)) { // attack2
			anim.SetInteger ("moving", 3);
		}
		if (Input.GetMouseButtonDown (2)) { // attack3
			anim.SetInteger ("moving", 6);
		}
//		if (Input.GetKeyDown ("space")) { //jump
//			anim.SetInteger ("moving", 6);
//		}
		if (Input.GetKeyDown ("c")) { //roar/howl
			anim.SetInteger ("moving", 7);
		}

		if (Input.GetKeyDown("p")) // defence_start
		{
			anim.SetInteger("moving", 11);
		}
		if (Input.GetKeyUp("p")) // defence_end
		{
			anim.SetInteger("moving", 12);
		} 

		
		if (Input.GetKeyDown ("u")) //hit
		{ 			  
			battle_state = 1;
			runSpeed = r_sp;
			anim.SetInteger ("battle", 1);
				
			int n = Random.Range (0, 2);
			if (n == 1) 
				{
					anim.SetInteger ("moving", 8);
				} 
			else 
				{
					anim.SetInteger ("moving", 9);
				}
		}


//-------------------------------------------------------------------TURNS

		var vert_modul = Mathf.Abs(Input.GetAxis("Vertical"));
		Debug.Log(vert_modul);
		
		if ((Input.GetAxis ("Horizontal") > 0.1f)&&(vert_modul > 0.3f)) 
		{
			anim.SetLayerWeight(1,1f);
			anim.SetBool ("turn_right", true);
		} else if (vert_modul > 0.3f)
		{
			anim.SetBool ("turn_right", false);
			//anim.SetLayerWeight(1,0f);
		}
		
		if ((Input.GetAxis ("Horizontal") < -0.1f)&&(vert_modul > 0.3f)) 
		{
			anim.SetLayerWeight(1,1f);
			anim.SetBool ("turn_left", true);
		} else if (vert_modul > 0.3f)
		{
			anim.SetBool ("turn_left", false);
			//anim.SetLayerWeight(1,0f);
		}
		
//----------------------------------------------------------------------------------------

		if (Input.GetKeyDown ("o")) 
			{	
				anim.SetInteger ("moving", 14); //die2
				anim.SetBool ("turn_left", false);
				anim.SetBool ("turn_right", false);		
			}

		if (controller.isGrounded) 
		{
			moveDirection=transform.forward * Input.GetAxis ("Vertical") * speed * runSpeed;
			//if (Mathf.Abs(Input.GetAxis ("Vertical")) > 0.2f)
			if (vert_modul > 0.2f)
				{
					float turn = Input.GetAxis("Horizontal");
					transform.Rotate(0, turn * turnSpeed * Time.deltaTime, 0);		
				}
		}
		moveDirection.y -= gravity * Time.deltaTime;
		controller.Move (moveDirection * Time.deltaTime);
		}
}



