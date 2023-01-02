from typing import Literal

from pydantic import BaseModel, confloat


class RequestModel(BaseModel):
    message: str

    class Config:
        schema_extra = {
            "example": {
                "message": "Sounds good to me",
            }
        }


class ResponseModel(BaseModel):
    label: Literal["happy", "sad"]
    label_probability: confloat(ge=0, le=1)
