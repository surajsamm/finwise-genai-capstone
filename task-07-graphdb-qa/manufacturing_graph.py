# manufacturing_graph.py
import os
from langchain_community.graphs import Neo4jGraph
from langchain_groq import ChatGroq
from langchain.chains import GraphCypherQAChain
from langchain.prompts import PromptTemplate
from dotenv import load_dotenv
import gradio as gr

# Load environment variables
load_dotenv()

class ManufacturingGraphQA:
    def __init__(self):
        # Neo4j connection details
        self.neo4j_url = os.getenv("NEO4J_URI")
        self.neo4j_username = os.getenv("NEO4J_USERNAME")
        self.neo4j_password = os.getenv("NEO4J_PASSWORD")
        self.neo4j_database = os.getenv("NEO4J_DATABASE", "neo4j")
        
        # Initialize Neo4j graph
        self.graph = Neo4jGraph(
            url=self.neo4j_url,
            username=self.neo4j_username,
            password=self.neo4j_password,
            database=self.neo4j_database
        )
        
        # Initialize LLM
        self.llm = ChatGroq(
            groq_api_key=os.getenv("GROQ_API_KEY"),
            model_name="llama-3.1-8b-instant",
            temperature=0
        )
        
        # Cypher generation prompt
        self.cypher_prompt = PromptTemplate(
            input_variables=["schema", "question"],
            template="""You are an expert Neo4j Cypher query translator. 
            Convert the following natural language question into an appropriate Cypher query.

            Database Schema:
            {schema}

            Question: {question}

            Guidelines:
            - Use MATCH clauses to find patterns
            - Use WHERE for filtering
            - Use RETURN to specify what to return
            - Use ORDER BY and LIMIT for sorting and limiting
            - Focus on relationships between Machine, Operator, Supplier, Product, Defect nodes

            Cypher Query:"""
        )
        
        # QA chain
        self.cypher_chain = GraphCypherQAChain.from_llm(
            llm=self.llm,
            graph=self.graph,
            verbose=True,
            return_intermediate_steps=True
        )
    
    def get_schema(self):
        """Get the database schema"""
        return self.graph.get_schema()
    
    def test_connection(self):
        """Test Neo4j connection"""
        try:
            result = self.graph.query("RETURN 'Connection successful' as result")
            return True, "✅ Neo4j connection successful"
        except Exception as e:
            return False, f"❌ Neo4j connection failed: {e}"
    
    def query_graph(self, question):
        """Query the graph with natural language"""
        try:
            result = self.cypher_chain.invoke({"query": question})
            return result
        except Exception as e:
            return {"error": str(e)}
    
    def get_sample_queries(self):
        """Return sample queries for users"""
        return [
            "Which machines have the highest defect rates?",
            "Find all operators working on shift A",
            "Which suppliers are linked to dimensional defects?",
            "What products are produced by machines operated by Raj Sharma?",
            "Which machines using Steel Masters as supplier have defects?",
            "Find the defect rate by supplier and machine type",
            "Which operators work with multiple machines?",
            "What is the average efficiency by machine type?",
            "Find suppliers with reliability issues linked to defects",
            "Which shift has better quality output?"
        ]

# Initialize the graph QA system
manufacturing_qa = ManufacturingGraphQA()

# Gradio interface
def query_manufacturing_graph(question):
    """Gradio interface function"""
    if not question.strip():
        return "Please enter a question about the manufacturing graph."
    
    result = manufacturing_qa.query_graph(question)
    
    if "error" in result:
        return f"Error: {result['error']}"
    
    response = f"**Question:** {question}\n\n"
    response += f"**Answer:** {result['result']}\n\n"
    
    if 'intermediate_steps' in result:
        cypher_query = result['intermediate_steps'][0]['query']
        response += f"**Cypher Query Used:**\n```cypher\n{cypher_query}\n```\n\n"
    
    return response

# Create interface
with gr.Blocks() as demo:
    gr.Markdown("# 🏭 Manufacturing Knowledge Graph QA")
    gr.Markdown("Ask questions about machines, operators, suppliers, products, and defects relationships.")
    
    # Connection status
    status_btn = gr.Button("Test Connection")
    status_output = gr.Textbox(label="Connection Status")
    
    # Sample queries
    gr.Markdown("### Sample Queries")
    sample_queries = manufacturing_qa.get_sample_queries()
    for i, query in enumerate(sample_queries, 1):
        gr.Markdown(f"{i}. {query}")
    
    # Query interface
    question = gr.Textbox(
        label="Your Question",
        placeholder="e.g., Which machines have the highest defect rates?"
    )
    submit_btn = gr.Button("Ask")
    output = gr.Markdown(label="Answer")
    
    # Schema viewer
    with gr.Accordion("View Database Schema"):
        schema_text = gr.Textbox(
            value=manufacturing_qa.get_schema(),
            lines=10,
            label="Graph Schema"
        )
    
    # Event handlers
    def test_connection():
        success, message = manufacturing_qa.test_connection()
        return message
    
    status_btn.click(test_connection, outputs=status_output)
    submit_btn.click(query_manufacturing_graph, inputs=question, outputs=output)
    question.submit(query_manufacturing_graph, inputs=question, outputs=output)

if __name__ == "__main__":
    # Test connection first
    success, message = manufacturing_qa.test_connection()
    print(message)
    
    if success:
        print("🚀 Starting Manufacturing Graph QA System...")
        print("👉 Open http://127.0.0.1:7860 in your browser")
        demo.launch(server_name="127.0.0.1", server_port=7860)
    else:
        print("❌ Cannot start system. Please check Neo4j connection.")