import React from "react";
import Layout from "@theme/Layout";
// import styles from "./index.module.css";
import "./styles.css"
import Link from "@docusaurus/Link";

export default function Home(){
    return(
        <Layout title={"PowerHorseEngine"}>
        <main>
            <div className="hero-section">
                <p className="hero-heading">PowerHorseEngine</p>
                <p>
                    PowerHorseEngine is an object-oriented ROBLOX Framework that provides the ability to create custom classes and has a bunch out of the box classes, services & built in libraries
                </p>
                <Link
                    className="button button--secondary button--lg"
                    to="/docs/intro"
                >Get Started →
                </Link>
            </div>
        </main>
      </Layout>
    )
}