    using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{
    //Movement Vars
    CharacterController cc;
    [SerializeField] bool rawMovement;          // Keep off with rm and on and sm
    [SerializeField] float movementSpeed;       // 9
    [SerializeField] float movementAir;         // 6
    [SerializeField] float jumpSpeed;           // 2
    [SerializeField] float jumpCurve;           // 0.1
    [SerializeField] float gravity;             // 25
    public int outgoingDamage;
    float finalJumpCalc;
    public bool isJumping;
    Vector3 velocity;

    [SerializeField] bool isAttacking;
    [SerializeField] float attackColliderRadius;

    //anims
    public Animator playerAnimator;
    [SerializeField] bool comboPossible;
    public int comboStep = 0;

    Vector2 input;
    [SerializeField] float accell; //4
    [SerializeField] float decell; //3
    float movementDir;

    //slopefix downforces
    [SerializeField] float slopeForce = 12;     //12 best value
    [SerializeField] float slopeForceRayLength; //3
    [SerializeField] float slideDownSpeed;      //8
    RaycastHit slopeHit;
    RaycastHit ccHit;

    //turning & cam refs
    float turnSmoothVelocity;
    [SerializeField] float turnSmoothTime = 0.1f; //0.1f
    public Transform cameraRig;

    CharacterManager characterManager;
    [SerializeField] LevelSystem levelSystem;

    public bool isMovingAbility;
    Transform hitboxPos;

    PlayerFamiliar playerFamiliar;

    [SerializeField] InventoryInput inventoryCheck;

    public bool isRolling = false;
    bool lockForward;

    [SerializeField] AudioSFX sfx;
    [SerializeField] SwordVFX swordVFXScript;
    [SerializeField] ParticleSystem fancyStepVFX;

    public static PlayerManager instance;

    [SerializeField] bool creditObject;

    private void Awake()
    {
        if (!creditObject)
        {
            if (instance != null)
            {
                Destroy(this.gameObject);
            }
            else
            {
                instance = this;
                DontDestroyOnLoad(this.gameObject);
            }
        }
    }

    // Start is called before the first frame update
    void Start()
    {

        playerFamiliar = GameObject.FindGameObjectWithTag("Familiar").GetComponent<PlayerFamiliar>();

        hitboxPos = transform.GetChild(1);
        isMovingAbility = false;
        if(levelSystem == null)
        {
            levelSystem = LevelSystem.instance;
        }
        cameraRig = GameObject.FindGameObjectWithTag("CameraManager").transform;
        characterManager = GetComponent<CharacterManager>();
        cc = GetComponent<CharacterController>();
        playerAnimator = GetComponent<Animator>();
        finalJumpCalc = Mathf.Sqrt(2 * gravity * jumpSpeed);
    }

    void Update()
    {
        if (!IngameMenu.gameIsPaused && !CharacterManager.isDead)
        {
            //Debug.Log(comboStep);
            //CCGroundCheckFunc();
            RawMovementFunc();
            isAttackCheck();
            if (Input.GetKeyDown(KeyCode.R))
            {
                playerFamiliar.callFamiliarBack = true;
                Debug.Log("Calling back Familiar");
            }

            if (!isMovingAbility)
            {
                if (Input.GetKeyDown(KeyCode.Space) && !isAttacking && !isRolling)
                {
                    PlayerJump();
                }


                if (Input.GetKeyDown(KeyCode.LeftShift) && !isAttacking && !isJumping && !isRolling)
                {
                    characterManager.CombatRoll();
                }
                characterManager.StaminaRegeneration();

                if (Input.GetKey(KeyCode.Mouse0) && !isJumping && !isRolling && !inventoryCheck.activePanel)// && !isAttacking)
                {
                    Attacking();
                }

                BlendTreeAnimations();
            }
            else
            {
                playerAnimator.SetFloat("rmVelocity", 0);
            }
        }
    }
    
    
    private void LateUpdate()
    {
        if (!isMovingAbility && !CharacterManager.isDead)
        {
            if (!isAttacking)
            {
                MainMovement();
            }
            RotationTransformCamera();
        }
    }
    


    void BlendTreeAnimations()
    {
        if (input.x != 0 || input.y != 0)
        {
            //moving
            movementDir += accell * Time.deltaTime;
        }
        else if (input.x == 0 && input.y == 0)
        {
            movementDir -= decell * Time.deltaTime;
        }

        movementDir = Mathf.Clamp(movementDir, 0, 1);
        playerAnimator.SetFloat("rmVelocity", movementDir);
    }

    public void StopPlayerAnim()
    {
        playerAnimator.SetFloat("rmVelocity", 0);
    }

    void CCGroundCheckFunc()
    {
        if (cc.isGrounded)
        {
            Debug.Log("grounded");
        }
        else
        {
            Debug.Log("Not Grounded");
        }
    }

    void RawMovementFunc()
    {
        if (rawMovement)    //!!!DISABLE SNAP IN INPUT PROJ SETTINGS FOR BETTER TURNING WHEN IT COMES TO RM OR ***USE SNAP & DONT USE RAW FOR BETTER RESULTS***
        {
            input.x = Input.GetAxisRaw("Horizontal");
            input.y = Input.GetAxisRaw("Vertical");
        }
        else
        {
            input.x = Input.GetAxis("Horizontal");
            input.y = Input.GetAxis("Vertical");
        }
    }

    void isAttackCheck()
    {
        if (comboStep >= 1)
        {
            isAttacking = true;
            swordVFXScript.enabled = true;
        }
        else
        {
            isAttacking = false;
        }
    }

    

    public void MainMovement()
    {
        if (OnSteepSlope())
        {
            cc.Move(SteepSlopeSlide() + Vector3.down * slopeForce);
            isJumping = true;
        }
        else if (isJumping) //or also in air
        {
            AirUpdate();
        }
        else //isgrounded
        {
            if (!isRolling)
            {
                GroundedUpdate();
            }
        }
    }


    #region Player Attack Related Funcs

    public void Attacking()
    {

        if (comboStep == 0)
        {
            playerAnimator.SetTrigger("Attack1");// + comboStep);
            comboStep = 1;
            comboPossible = false;
            return;
        }
        
        if(comboStep != 0)
        {
            if (comboPossible && comboStep < 4)
            {
                comboPossible = false;
                comboStep += 1;
            }
        }
    }

    bool endCombo = false;

    public void ComboPossible()
    {
        comboPossible = true;
    }

    public void Combo()
    {
        if (comboPossible)
        {
            comboPossible = false;
            endCombo = true;
            return;
        }

        if (comboStep == 2)
        {
            playerAnimator.SetTrigger("Attack2");// + comboStep);
        }

        if (comboStep == 3)
        {
            playerAnimator.SetTrigger("Attack3");// + comboStep);
        }

        if (comboStep == 4)
        {
            playerAnimator.SetTrigger("AttackLoop");
            comboStep = 1;
        }
    }

    public void EndOfAttack()
    {
        if (!endCombo)
        {
            return;
        }
        else
        {
            isAttacking = false;
            comboPossible = false;
            endCombo = false;
            comboStep = 0;
            return;
        }
    }

    /// <summary>
    /// REVIST THIS DETECTION FOR ENEMIES HIT MAYBE USE A DIFF IN THE FUTURE THIS WAS ORIGINALLY PALCEHODLER
    /// </summary>
    Collider[] hitColliders;
    bool oneRunFamiliar = true;
    void PeakOfAttack()
    {
        Debug.Log("Peak of Attack");
        //MIGHT USE ANOTHER TYPE OF COLLISION LOGIC HERE THIS IS PLACE HOLDER

        sfx.SwordSwingSFX();

        hitColliders = Physics.OverlapSphere(hitboxPos.transform.position, attackColliderRadius);

        //out going dmg calc maybe change in the future for better results to scale to higher lvls
        int levelBasedDmg = (int)((levelSystem.currentLevel + 10) * Random.Range(0.7f,1.2f));//help early game be useless lategame
        outgoingDamage = (int)(characterManager.Strength.Value * Random.Range(0.8f, 1.5f) + levelBasedDmg); //help lategame be useless early game


        foreach (Collider hitCollider in hitColliders)
        {
            if (hitCollider.tag == "Enemy" || hitCollider.tag == "Boss")
            {
                Debug.Log("I just hit an enemey");
                //hitCollider.GetComponent<SimpleEnemy>().TakeDamageFromPlayer(outgoingDamage);
                hitCollider.GetComponent<EnemyStatManager>().TakeDamageFromPlayer(outgoingDamage);
                if (oneRunFamiliar)
                {
                    playerFamiliar.lastestEnemyHit = hitCollider.GetComponent<EnemyStatManager>().gameObject;
                    playerFamiliar.isEnemyHit = true;
                    oneRunFamiliar = false;
                }
            }
        }
        oneRunFamiliar = true;
    }

    uint attackID;

    public void DashID()
    {
        //When sword is swung
        attackID = (uint) Random.Range(0, uint.MaxValue);
    }

    public void DashAttack()
    {
        hitColliders = Physics.OverlapSphere(transform.position + transform.forward + transform.up, attackColliderRadius);

        int levelBasedDmg = (int)((levelSystem.currentLevel + 8) * Random.Range(1f, 1.2f));

        outgoingDamage = (int)(characterManager.Strength.Value * Random.Range(0.8f, 1.2f) + levelBasedDmg);

        foreach (Collider hitCollider in hitColliders)
        {
            if (hitCollider.tag == "Enemy" || hitCollider.tag == "Boss")
            {
                Debug.Log("I just hit an enemey");
                if (hitCollider.GetComponent<EnemyStatManager>().hitID != attackID)
                {
                    // Hit enemy
                    hitCollider.GetComponent<EnemyStatManager>().hitID = attackID;
                    hitCollider.GetComponent<EnemyStatManager>().TakeDamageFromPlayer(outgoingDamage);
                }
            }
        }
    }

    public void AOEAttack()
    {
        hitColliders = Physics.OverlapSphere(transform.position, 7);

        int levelBasedDmg = (int)((levelSystem.currentLevel + 6) * Random.Range(1f, 1.2f));

        outgoingDamage = (int)(characterManager.Strength.Value * Random.Range(0.8f, 1f) + levelBasedDmg);

        foreach (Collider hitCollider in hitColliders)
        {
            if (hitCollider.tag == "Enemy" || hitCollider.tag == "Boss")
            {
                Debug.Log("I just hit an enemey");
                hitCollider.GetComponent<EnemyStatManager>().TakeDamageFromPlayer(outgoingDamage);
            }
        }
    }
    #endregion Player Attack Related Funcs

    public void GroundedUpdate()
    {
        if (!fancyStepVFX.isPlaying)
        {
            fancyStepVFX.Play();
        }

        Vector3 downSlopeFix = (Vector3.down * cc.height / 2 * slopeForce);

        Vector3 forwardRightMovement = (cameraRig.transform.forward * input.y) + (cameraRig.transform.right * input.x); 

        Vector3 finalVelo = forwardRightMovement + downSlopeFix;

        if (forwardRightMovement.magnitude > 0)
        {
            forwardRightMovement.Normalize();
            forwardRightMovement *= movementSpeed * Time.deltaTime;
            cc.Move(forwardRightMovement + downSlopeFix);
        }

        if (!cc.isGrounded)
        {
            cc.Move(-downSlopeFix * Time.deltaTime);
            SetInAir(0);
            return;
        }
    }

    private void AirUpdate()
    {
        fancyStepVFX.Stop();
        velocity.y -= gravity * Time.deltaTime;
        Vector3 displacement = velocity * Time.deltaTime;
        displacement += AirMovement();
        cc.Move(displacement);
        isJumping = !cc.isGrounded;
        playerAnimator.SetBool("isJumping", isJumping);
    }

    public void DeadAirUpdate()
    {
        velocity.y -= gravity * Time.deltaTime;
        Vector3 displacement = velocity * Time.deltaTime;
        displacement += AirMovement();
        if (!cc.isGrounded)
        {
            cc.Move(displacement);
        }
    }

    void PlayerJump()
    {
        if (!isJumping)
        {
            SetInAir(finalJumpCalc);
        }
    }

    void SetInAir(float jumpVelo)
    {

        isJumping = true;
        velocity = cc.velocity.normalized * (movementSpeed * jumpCurve);
        playerAnimator.SetBool("isJumping", true);
        velocity.y = jumpVelo;
    }

    Vector3 AirMovement()
    {
        return ((cameraRig.transform.forward * input.y) + (cameraRig.transform.right * input.x)).normalized * movementAir * Time.deltaTime;
    }

    bool OnSteepSlope()
    {
        if (!cc.isGrounded)
        {
            return false;
        }

        if (Physics.Raycast(transform.position + (transform.forward * 0.1f), Vector3.down, out slopeHit, (cc.height/2) + slopeForceRayLength))
        {
            float slopeAngle = Vector3.Angle(slopeHit.normal, Vector3.up);
            if(slopeAngle > cc.slopeLimit)
            {
                return true;
            }
        }
        return false;
    }

    Vector3 SteepSlopeSlide()
    {
        Vector3 slopeDir = Vector3.up - slopeHit.normal * Vector3.Dot(Vector3.up, slopeHit.normal);
        float slideSpeed = slideDownSpeed + Time.deltaTime;

        Vector3 moveDir = slopeDir * -slideSpeed;
        moveDir.y = moveDir.y - slopeHit.point.y;
        return moveDir * Time.deltaTime;
    }

    bool oneRun;

    void RotationTransformCamera()
    {
        /*
        Vector2 input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
        float targetAngle = Mathf.Atan2(input.x, input.y) * Mathf.Rad2Deg + cameraRig.eulerAngles.y;
        float angle = Mathf.SmoothDampAngle(transform.eulerAngles.y, targetAngle, ref turnSmoothVelocity, turnSmoothTime);
        //Vector3 moveDir = Quaternion.Euler(0f, targetAngle, 0f) * Vector3.forward;
        transform.rotation = Quaternion.Euler(0f, angle, 0f);
        */

        if (isAttacking || isRolling)
        {
            lockForward = true;
        }
        else
        {
            lockForward = false;
        }

        if (!lockForward)
        {
            Vector2 input = new Vector2(Input.GetAxisRaw("Horizontal"), Input.GetAxisRaw("Vertical"));
            Vector2 inputDir = input.normalized;
            //rotation transform
            oneRun = false;
            if (inputDir != Vector2.zero)
            {
                float targetRot = Mathf.Atan2(input.x, input.y) * Mathf.Rad2Deg + cameraRig.eulerAngles.y;
                transform.eulerAngles = Vector3.up * Mathf.SmoothDampAngle(transform.eulerAngles.y, targetRot, ref turnSmoothVelocity, turnSmoothTime);
            }
             
        }
        else
        {
            if (!oneRun)
            {
                float targetRot = cameraRig.eulerAngles.y;
                transform.eulerAngles = Vector3.up * Mathf.SmoothDampAngle(transform.eulerAngles.y, targetRot, ref turnSmoothVelocity, 0);
                oneRun = true;
            }
        }
        
    }

    public bool GetIsAttackingBool()
    {
        return isAttacking;
    }

    private void OnDrawGizmos()
    {
        //Gizmos.color = Color.black;
        //Gizmos.DrawWireSphere(transform.position + transform.forward + transform.up, attackColliderRadius);
        Gizmos.color = Color.green;
        Gizmos.DrawWireSphere(transform.position, 7);
        if (hitboxPos != null)
        {
            Gizmos.color = Color.yellow;
            Gizmos.DrawWireSphere(hitboxPos.transform.position, attackColliderRadius);
        }
    }

    void OnControllerColliderHit(ControllerColliderHit hit)
    {
        ccHit.normal = hit.normal;
    }

    public float GetPlayerSpeed()
    {
        return movementSpeed;
    }

}
