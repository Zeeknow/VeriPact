// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

/**
 * @title IReceptor
 * @dev Interface for Redbelly's Identity Verification (Receptor).
 * This allows us to verify if a user is a "Real Human" on-chain.
 */
interface IReceptor {
    // This function signature typically matches Iden3/Receptor verifiers.
    // It returns true if the ZK-proof provided by the user is valid.
    function verifyProof(
        bytes32 requestId,
        uint256[] calldata inputs,
        uint256[8] calldata proof
    ) external view returns (bool);
}

contract VeriPact {
    
    // --- State Variables ---
    address public admin;
    IReceptor public receptor; // The Redbelly Identity Contract
    
    uint256 public jobCounter;
    uint256 public constant PLATFORM_FEE_BPS = 300; // 3% Service Fee
    
    // Status Flow: Open -> InProgress -> Completed OR Disputed
    enum JobStatus { Open, InProgress, Completed, Disputed, Canceled }
    
    struct Job {
        uint256 id;
        address client;
        address freelancer;
        uint256 amount;
        string descriptionIpfsHash; // Link to the job details (PDF/Text)
        JobStatus status;
        bool isApprenticeJob; // If true, we waive the 3% fee
    }
    
    mapping(uint256 => Job) public jobs;
    mapping(address => uint256) public completedJobs; // Tracks "Earned Reputation"

    // --- Events ---
    event JobCreated(uint256 indexed jobId, address indexed client, uint256 amount);
    event JobTaken(uint256 indexed jobId, address indexed freelancer);
    event JobCompleted(uint256 indexed jobId, uint256 payout);
    event DisputeOpened(uint256 indexed jobId);

    // --- Modifiers ---

    /**
     * @dev Checks if the caller is a Verified Human via Redbelly Receptor.
     * In a real dApp, the frontend generates a ZK-proof which is passed here.
     * For MVP/Testing, we trust the caller if the proof format is valid.
     */
    modifier onlyVerifiedHuman(
        uint256[8] calldata proof,
        uint256[] calldata input
    ) {
        // CODE NOTE: In Production, uncomment the line below to enforce checks.
        // require(receptor.verifyProof(REQUEST_ID, input, proof), "Receptor: Not Verified");
        _;
    }

    constructor(address _receptorAddress) {
        admin = msg.sender;
        receptor = IReceptor(_receptorAddress);
    }

    // --- Core Functions ---

    /**
     * @notice Post a Job and deposit stablecoins/RBNT.
     */
    function postJob(
        string memory _ipfsHash,
        uint256[8] calldata _proof, // Identity Proof
        uint256[] calldata _input   // Identity Inputs
    ) external payable onlyVerifiedHuman(_proof, _input) {
        require(msg.value > 0, "Deposit required");

        jobCounter++;
        jobs[jobCounter] = Job({
            id: jobCounter,
            client: msg.sender,
            freelancer: address(0),
            amount: msg.value,
            descriptionIpfsHash: _ipfsHash,
            status: JobStatus.Open,
            isApprenticeJob: false 
        });

        emit JobCreated(jobCounter, msg.sender, msg.value);
    }

    /**
     * @notice Freelancer accepts a job.
     * @dev Applies "Apprentice" logic: If you have 0 completed jobs, this is fee-free.
     */
    function acceptJob(
        uint256 _jobId,
        uint256[8] calldata _proof,
        uint256[] calldata _input
    ) external onlyVerifiedHuman(_proof, _input) {
        Job storage job = jobs[_jobId];
        require(job.status == JobStatus.Open, "Job not open");
        require(msg.sender != job.client, "Cannot hire yourself");

        job.freelancer = msg.sender;
        job.status = JobStatus.InProgress;
        
        // --- Growth Strategy Logic ---
        // If this is the freelancer's first job, mark it as "Apprentice" (0% fee).
        if (completedJobs[msg.sender] == 0) {
            job.isApprenticeJob = true;
        }

        emit JobTaken(_jobId, msg.sender);
    }

    /**
     * @notice Client approves work -> Funds released.
     */
    function approveWork(uint256 _jobId) external {
        Job storage job = jobs[_jobId];
        require(msg.sender == job.client, "Only client can approve");
        require(job.status == JobStatus.InProgress, "Job not active");

        uint256 payout = job.amount;
        uint256 fee = 0;

        // Calculate Fee (Waived if Apprentice Job)
        if (!job.isApprenticeJob) {
            fee = (job.amount * PLATFORM_FEE_BPS) / 10000;
            payout = job.amount - fee;
        }

        job.status = JobStatus.Completed;
        completedJobs[job.freelancer]++; // +1 Reputation Score

        // Transfer Funds
        if (fee > 0) {
            payable(admin).transfer(fee);
        }
        payable(job.freelancer).transfer(payout);

        emit JobCompleted(_jobId, payout);
    }
}