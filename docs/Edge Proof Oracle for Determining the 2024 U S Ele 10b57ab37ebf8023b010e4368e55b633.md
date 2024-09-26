# Edge Proof Oracle for Determining the 2024 U.S. Election Winner

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image.png)

## Introduction

**Edge Proofs Oracles** ensure data provenance, integrity, and authenticity, enabling blockchain applications to trust the external data they rely on, and subsequently use this data to determine the outcome of real world events. 

This capability is crucial for **Prediction Market Oracles**, a specialized subset of proof oracles designed to bring off-chain data on chain in a secure and trusted manner, ensuring accurate verification of real-world outcomes like elections.

The Prediction Market Oracle mechanism works as follows:

1. **Declare Reputable Sources**: Trusted sources like the Associated Press, NBC, or Fox are designated in advance. These serve as the inputs for resolving prediction market events, such as determining the winner of a U.S. election.
2. **Prove Data Provenance, Integrity, and Authenticity**: The oracle ensures that the data remains in its original form, untampered, and precisely as published by the declared sources, preserving the integrity of the input.
3. **Determine Event Outcome**: Each Node’s Orchestrator frontier LLM model processes the text and is prompted with the following task: “**Task**: Based solely on the **provided documents** from the Associated Press (AP), Fox News, and NBC, extract whether a winner has been declared by each source for the 2024 U.S. Presidential Election.” Requirements include
    1. **Objectivity**: Do not include personal opinions, interpretations, or predictions.
    2. **Clarity**: Ensure your response is clear and unambiguous.
    3. **Formatting**: Strictly adhere to the JSON response format provided.
    
    ```json
    {
      "sources": {
        "AP": "Jane Doe",
        "FoxNews": "Not Declared",
        "NBC": "Jane Doe"
      }
    }
    ```
    
4. **Achieve Consensus**: To ensure the reliability of the outcome, the oracle network achieves consensus among multiple nodes. This step guarantees that no single entity can unilaterally determine the event's outcome, ensuring transparency and decentralization.

Crucially, Prediction Market Oracles do not act as arbiters of truth but ensure that trusted data sources and transparent methods are used to resolve event outcomes. This approach delivers a scalable, decentralized solution while minimizing human bias and intervention.

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%201.png)

<aside>
💡

**Note**: For transparency, the documents selected by the LLM, used for result outcome determination, will be posted to a GitHub repository.

</aside>

---

## Oracle Solution Workflow

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%202.png)

To effectively determine the winner of the U.S. elections using machine learning, we propose a structured approach that leverages LLMs for scalability and objectivity.

### Overview

1. **LLM Crawler Algorithm**: Collects high-quality, objective data from reputable sources.
2. **LLM Document Selector**: Filters and refines the collected documents to ensure neutrality, objectivity, and relevance.
3. **LLM Consensus Algorithm**: Utilizes multiple LLMs to interpret the data and reach a unanimous decision on the election outcome.

---

## 1. LLM Crawler Algorithm

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%203.png)

**Objective**: Gather factual and objective information regarding the election outcome from trusted sources.

### Process

- **Keyword Filtering**:
    - Crawl web pages for specific keywords related to the event (e.g., "2024 U.S. Presidential Election Winner").
    - Filter out irrelevant content such as opinion pieces and advertisements.
- **Document Ranking**:
    - Assign a confidence score to each document based on source credibility and content stability.
    - Favor articles that remain unchanged over time or maintain consistent semantic meaning.
- **Snapshotting**:
    - Take hourly snapshots over 24 hours on designated days to capture the most up-to-date information.
- **Data Extraction**:
    - Use tools like **EventCrawler** to scrape and extract clean, structured data suitable for LLM processing.
- **Transparency**:
    - All documents the LLM selects will be posted to a GitHub repository for public verification.

---

## 2. LLM Document Selector

**Objective**: Filter and select neutral, objective, and directly relevant documents to determine the specific event outcome.

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%204.png)

### Process

- **Prompt Engineering and Multi-Agent Framework**:
    - Employ prompt engineering to guide LLMs in evaluating documents based on specific criteria.
    - Implement a multi-agent orchestration framework where multiple agents collaborate to assess and filter documents.
    - Each node in the consensus algorithm uses this multi-step, multi-agent framework, with each node employing a different frontier model as the orchestrator.
- **Filtering Criteria**:
    1. **Neutral Sentiment**:
        - Analyze documents to ensure they exhibit neutral sentiment.
        - Exclude documents with biased or subjective language.
    2. **Objectivity Assessment**:
        - Prioritize factual reporting over opinion pieces or editorials.
        - Remove documents that lack objectivity.
    3. **Hard-News Category**:
        - Focus on hard-news articles that report events without interpretation.
        - Filter out soft news or feature stories that do not contribute to determining the outcome.
    4. **Relevance Check**:
        - Ensure the documents are directly related to the specific event outcome.
        - Discard any content that is not pertinent to determining who won the election.
- **Information Extraction**:
    - Remove non-relevant information to concentrate on the core task.
    - Extract key information that directly pertains to the event outcome.
    - Format the extracted content into a standardized structure (e.g., JSON).

### Multi-Agent Framework Steps

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%205.png)

1. **Initial Document Collection**:
    - Start with the set of documents gathered by the LLM Crawler Algorithm.
2. **Sentiment Analysis Agent**:
    - Evaluate each document for sentiment neutrality.
    - Filter out documents exhibiting bias or strong subjective language.
3. **Objectivity Assessment Agent**:
    - Assess the objectivity of the remaining documents.
    - Remove any documents that are opinionated or not fact-based.
4. **Relevance Agent**:
    - Check the relevance of documents to the specific event outcome.
    - Exclude documents that do not provide direct information about the election results.
5. **Content Extraction Agent**:
    - Extract essential information related to the event outcome.
    - Eliminate any extraneous data or commentary.
6. **Final Document Compilation**:
    - Compile the filtered and processed documents.
    - Prepare the data for input into the LLM Consensus Algorithm.

### Diversity Through Different Frontier Models

- **Node Diversity**:
    - Each node in the consensus algorithm uses a different frontier model (e.g., GPT-4, Claude, Llama) as the orchestrator in the multi-agent framework.
    - This approach enhances diversity in data processing and reduces the risk of systemic biases.
- **Multi-Step Execution**:
    - Nodes execute the multi-agent framework in steps, ensuring thorough filtering and evaluation at each stage.
    - Different models may interpret data slightly differently, but the consensus mechanism ensures alignment on the final outcome.

---

## 3. LLM Consensus Algorithm

**Objective**: Achieve a unanimous decision on the election outcome using multiple leading LLMs.

### Process

- **Model Selection**:
    - Utilize top-tier models such as OpenAI's GPT-4, Anthropic's Claude, and Meta's Llama.
- **Data Consensus**:
    - Ensure all models agree on the input data by cross-validating the extracted information from the LLM Document Selector.
- **Event Extraction**:
    - Each model independently runs an event extraction algorithm to interpret the results.
- **Result Formatting**:
    - Convert unstructured data into a standardized JSON format.
- **Edge Consensus Algorithm**:
    - Aggregate outputs from all models.
    - **Consensus Rule**: Require 100% agreement among the models for final event resolution.

### Consensus Example

<aside>
💡

Note: All outputs will have identical payload structure. 

</aside>

- **Scenario 1**: All Models Agree
    - **GPT-4 Output**: "The 2024 U.S. Presidential Election winner is Candidate A."
    - **Claude Output**: "Candidate A has won the 2024 U.S. Presidential Election."
    - **Llama Output**: "Candidate A is the projected winner of the 2024 election."
    - **Consensus Achieved**: **Yes** (All models agree on Candidate A).

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%206.png)

- **Scenario 2**: Models Disagree
    - **GPT-4 Output**: "Candidate A has won the election."
    - **Claude Output**: "The election results are still too close to call."
    - **Llama Output**: "Candidate A is leading, but no winner has been declared."
    - **Consensus Achieved**: **No** (Disagreement among models).

![image.png](Edge%20Proof%20Oracle%20for%20Determining%20the%202024%20U%20S%20Ele%2010b57ab37ebf8023b010e4368e55b633/image%207.png)

- **Action When No Consensus**:
    - Continue data collection and periodically rerun the consensus algorithm until all models agree.

---

## Timeline

### **Step 1: Pre-Election Preparation (October 2024)**

- **Data Source Selection**:
    - Identify and integrate APIs or feeds from trusted news outlets and official channels (e.g., Associated Press, CNN).
- **Model Calibration**:
    - Optimize LLM settings (e.g., temperature = 0, top-k = 1) to reduce output variability.
    - Fix random seeds to ensure consistent results.
- **Testing and Validation**:
    - Run simulations using past election data to validate system performance.
    - Verify that the LLMs and classifiers consistently parse and interpret results accurately.

### **Step 2: Election Day Monitoring (November 5, 2024)**

- **Real-Time Data Collection**:
    - Continuously monitor selected sources for live updates using the LLM Crawler Algorithm.
- **Document Selection and Filtering**:
    - Apply the LLM Document Selector to filter and refine the collected documents.
- **Initial Parsing**:
    - Use the LLM Consensus Algorithm to interpret early reports and extract preliminary results.

### **Step 3: Post-Election Workflow**

- **Early Winner Declaration**:
    - If major outlets project a winner on election night or the following morning, execute the consensus algorithm to confirm unanimous recognition.
- **Delayed Declaration Handling**:
    - In cases of close races or delayed counts, continue periodic data collection and analysis until a clear winner emerges.

### **Step 4: Final Declaration and Result Publication (Mid to Late November)**

- **Result Finalization**:
    - Publish the election winner once consensus is achieved and verified.
- **Data Archiving**:
    - Store raw data and model outputs for transparency and future audits.
    - All data and results will be available on the GitHub repository.

---

## Contingency for Unexpected Events

- **Legal Disputes and Recounts**:
    - Continue monitoring official statements and legal proceedings.
    - Update the outcome only if all models reach a new unanimous consensus based on verified information.

---

## Trust Model

- **Node Operator Integrity**:
    - Relies on trusted node operators within the Edge Network.
    - Node signatures on payloads are required for participation in the consensus process.
- **Decentralization and Transparency**:
    - No single entity can unilaterally determine the event's outcome.
    - All processes are transparent and verifiable by the public.

---

## Conclusion and Next Steps

This structured approach provides a robust and objective method for determining the U.S. election winner using advanced language models. Incorporating the LLM Document Selector ensures that only neutral, objective, and relevant information is used in the decision-making process.

The combination of comprehensive data collection, rigorous document filtering, and a unanimous consensus algorithm enables the system to handle typical scenarios and unexpected events effectively. Transparency measures, such as publishing selected documents and model outputs on GitHub, further ensure public trust and verifiability.

Further refinement and testing will enhance reliability as we approach the 2024 elections. We are committed to minimizing human bias and intervention, delivering a scalable and decentralized solution for accurate event outcome determination.

---